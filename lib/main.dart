import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootstrapApp());
}

/// Step 3: JSON, raster images, and vector assets via flutter_svg.
class _BootstrapApp extends StatelessWidget {
  const _BootstrapApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Planner',
      home: Scaffold(
        body: FutureBuilder<String>(
          future: rootBundle.loadString('assets/data/surahs.json'),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final raw = snapshot.data!;
            final map = jsonDecode(raw) as Map<String, dynamic>;
            final list = map['surahs'] as List<dynamic>;
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black26),
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/crescent_mark.svg',
                            width: 56,
                            height: 56,
                          ),
                          const SizedBox(height: 12),
                          Image.asset(
                            'assets/images/app_icon.png',
                            width: 72,
                            height: 72,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${list.length} seed surahs',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'SVG + PNG assets load from the bundle.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
