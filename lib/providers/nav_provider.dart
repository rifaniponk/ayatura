import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom navigation selection; drives tab shell UI reactively.
final navIndexProvider = StateProvider<int>((ref) => 0);
