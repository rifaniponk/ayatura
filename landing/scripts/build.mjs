#!/usr/bin/env node
import * as esbuild from "esbuild";
import { minify } from "html-minifier-terser";
import fs from "node:fs/promises";
import path from "node:path";
import sharp from "sharp";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
const dist = path.join(root, "dist");
const imageSrc = path.join(root, "assets", "images");
const imageDist = path.join(dist, "assets", "images");

const htmlPages = ["index.html", "privacy-policy.html"];

const phoneScreens = [
  "en-hifdh",
  "en-bulk",
  "en-home",
  "en-month",
  "en-read",
  "en-widget",
  "id-hifdh",
  "id-bulk",
  "id-home",
  "id-month",
  "id-read",
  "id-widget",
];

async function clean() {
  await fs.rm(dist, { recursive: true, force: true });
  await fs.mkdir(imageDist, { recursive: true });
}

async function optimizeImages() {
  await sharp(path.join(imageSrc, "logo.png"))
    .resize({ width: 400, withoutEnlargement: true })
    .webp({ quality: 82 })
    .toFile(path.join(imageDist, "logo.webp"));

  await Promise.all(
    phoneScreens.map(async (name) => {
      const maxWidth = name.endsWith("-widget") ? 800 : 640;
      await sharp(path.join(imageSrc, `${name}.png`))
        .resize({ width: maxWidth, withoutEnlargement: true })
        .webp({ quality: 80 })
        .toFile(path.join(imageDist, `${name}.webp`));
    }),
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

  const appPath = path.join(dist, "assets", "scripts", "app.js");
  let app = await fs.readFile(appPath, "utf8");
  app = app.replace(/assets\/images\/([a-z0-9-]+)\.png/g, "assets/images/$1.webp");
  await fs.writeFile(appPath, app);
}

function productionHtml(html, filename) {
  let output = html.replace(
    /assets\/images\/([a-z0-9-]+)\.png/g,
    "assets/images/$1.webp",
  );
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
  await optimizeImages();
  await Promise.all([buildStyles(), buildScripts()]);
  await buildHtml();
  console.log(`Done. Output: ${path.relative(process.cwd(), dist)}/`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
