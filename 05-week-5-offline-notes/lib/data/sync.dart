import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';
import 'local/post.dart';

/// Berisi semua logika SINKRONISASI (bukan CRUD biasa):
/// - syncNotes: upload catatan dirty ke "server" (simulasi)
/// - refreshPostsInBackground: fetch API + simpan ke cache

Future<int> syncNotes(NoteRepository repo) async {
  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;

  // Simulasi upload ke server (delay 1 detik)
  await Future.delayed(const Duration(seconds: 1));
  await repo.markAllSynced();
  return dirtyCount;
}

Future<List<Post>> refreshPostsInBackground(PostRepository repo) async {
  return repo.fetchAndCachePosts();
}