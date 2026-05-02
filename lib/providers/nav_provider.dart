import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom navigation selection; drives tab shell UI reactively.
class NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int value) => state = value;
}

final navIndexProvider =
    NotifierProvider<NavIndexNotifier, int>(NavIndexNotifier.new);
