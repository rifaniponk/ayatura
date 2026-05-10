part of '../quran_reader_sheet.dart';

class _VersesTab extends ConsumerWidget {
  const _VersesTab({required this.request});

  final QuranVerseRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context)!;
    final asyncVerses = ref.watch(quranVersesProvider(request));
    return asyncVerses.when(
      data: (verses) {
        if (verses.isEmpty) {
          return Center(child: Text(s.readerNoVerses));
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          itemCount: verses.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _AyahTile(verse: verses[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(
        child: TextButton.icon(
          onPressed: () => ref.refresh(quranVersesProvider(request)),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(s.readerLoadErrorRetry),
        ),
      ),
    );
  }
}
