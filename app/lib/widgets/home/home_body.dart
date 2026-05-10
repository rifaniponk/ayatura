part of '../../screens/home_screen.dart';

class _HomeBody extends ConsumerStatefulWidget {
  const _HomeBody({required this.surahs, required this.pool});

  final List<Surah> surahs;
  final List<SurahPoolEntry> pool;

  @override
  ConsumerState<_HomeBody> createState() => _HomeBodyState();
}
