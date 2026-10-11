import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/post_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/get_posts.dart';

// Data layer: implementasi disuntikkan lewat constructor
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl();
});

// Domain layer: use case menerima abstraksi
final getPostsProvider = Provider<GetPosts>((ref) {
  return GetPosts(ref.watch(postRepositoryProvider));
});

// Simulasi kondisi offline yang deterministik (untuk demo & testing)
class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final forceOfflineProvider =
    NotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

// Presentation layer: state untuk UI
final postsProvider =
    AsyncNotifierProvider<PostsNotifier, List<Post>>(PostsNotifier.new);

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    // Cache-first: tampilkan cache dulu, refresh di background
    final result = await ref.read(getPostsProvider).call(refresh: false);
    if (result.failure != null) throw Exception(result.failure!.message);

    _refreshInBackground();
    return result.posts;
  }

  Future<void> _refreshInBackground() async {
    final isForceOffline = ref.read(forceOfflineProvider);
    if (isForceOffline) return;

    final result = await ref.read(getPostsProvider).call(refresh: true);
    if (result.failure == null) ref.invalidateSelf();
  }
}
