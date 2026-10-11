import 'repositories/post_repository.dart';
import 'local/post.dart';

/// refreshPostsInBackground: fetch API + simpan ke cache.
/// (Logika sinkronisasi notes telah pindah ke use case SyncNotes.)

Future<List<Post>> refreshPostsInBackground(PostRepository repo) async {
  return repo.fetchAndCachePosts();
}
