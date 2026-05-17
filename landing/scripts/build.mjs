#!/usr/bin/env node
import * as esbuild from "esbuild";
import { minify } from "html-minifier-terser";
import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const dist = path.join(root, "dist");

const htmlPages = ["index.html", "privacy-policy.html"];

async function clean() {
  await fs.rm(dist, { recursive: true, force: true });
  await fs.mkdir(path.join(dist, "assets", "images"), { recursive: true });
}

async function copyImages() {
  await fs.cp(
    path.join(root, "assets", "images"),
    path.join(dist, "assets", "images"),
    { recursive: true },
  );
}

async function buildStyles() {
  const styles = ["main.css", "privacy.css"];
  await Promise.all(
    styles.map((name) =>
      esbuild.build({
        entryPoints: [path.join(root, "assets", "styles", name)],
        outfile: path.join(dist, "assets", "styles", name),
        bundle: true,
        minify: true,
        logLevel: "silent",
      }),
    ),
  );
}

async function buildScripts() {
  await esbuild.build({
    entryPoints: [path.join(root, "assets", "scripts", "main.js")],
    outfile: path.join(dist, "assets", "scripts", "app.js"),
    bundle: true,
    minify: true,
    format: "iife",
    target: "es2020",
    logLevel: "silent",
  });
}

function productionHtml(html, filename) {
  let output = html;
  if (filename === "index.html") {
    output = output.replace(
      '<script type="module" src="assets/scripts/main.js"></script>',
      '<script src="assets/scripts/app.js" defer></script>',
    );
  }
  return output;
}

async function buildHtml() {
  const minifyOptions = {
    collapseWhitespace: true,
    conservativeCollapse: true,
    removeComments: true,
    removeRedundantAttributes: true,
    removeScriptTypeAttributes: true,
    removeStyleLinkTypeAttributes: true,
    useShortDoctype: true,
  };

  await Promise.all(
    htmlPages.map(async (filename) => {
      const source = await fs.readFile(path.join(root, filename), "utf8");
      const prepared = productionHtml(source, filename);
      const minified = await minify(prepared, minifyOptions);
      await fs.writeFile(path.join(dist, filename), minified);
    }),
  );
}

async function main() {
  console.log("Building landing for production...");
  await clean();
  await copyImages();
  await Promise.all([buildStyles(), buildScripts()]);
  await buildHtml();
  console.log(`Done. Output: ${path.relative(process.cwd(), dist)}/`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
