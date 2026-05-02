import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _BootstrapApp());
}

/// Step 1: proves bundled JSON is on the asset bundle and parses.
class _BootstrapApp extends StatelessWidget {
  const _BootstrapApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Planner',
      home: Scaffold(
        appBar: AppBar(title: const Text('Bootstrap')),
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
            return Center(
              child: Text(
                'Loaded ${list.length} seed surahs from assets.',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
