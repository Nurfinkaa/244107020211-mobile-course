import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/note.dart';
import 'notes_page.dart'; // untuk noteRepositoryProvider

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final int noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(noteRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: FutureBuilder<Note?>(
        future: repo.fetchNoteById(noteId), // lihat catatan di bawah
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final note = snapshot.data;
          if (note == null) {
            return const Center(child: Text('Catatan tidak ditemukan'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(note.body),
                const SizedBox(height: 16),
                Text(
                  note.dirty ? 'Status: belum tersinkron' : 'Status: tersinkron',
                  style: TextStyle(color: note.dirty ? Colors.orange : Colors.green),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}