import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/post.dart';
import '../data/repositories/post_repository.dart';
import '../data/network_state.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(PostsNotifier.new);

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final repo = ref.watch(postRepositoryProvider);

    // 1. Segera kembalikan cache agar UI tidak blank saat offline
    final cached = await repo.readCachedPosts();

    // 2. Di background: fetch dari API -> simpan ke cache -> refresh provider
    _refreshInBackground(repo);

    return cached;
  }

  Future<void> _refreshInBackground(PostRepository repo) async {
    final isForceOffline = ref.read(forceOfflineProvider);
    if (isForceOffline) {
      return; // anggap tidak ada koneksi, cache lama tetap dipakai
    }

    try {
      await repo.fetchAndCachePosts();
      ref.invalidateSelf();
    } catch (_) {
      // gagal fetch beneran (misal WiFi mati) -> cache lama tetap dipakai
    }
  }
}

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);
    final isForceOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts (Cache-first)'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Force Offline', style: TextStyle(fontSize: 12)),
              Switch(
                value: isForceOffline,
                onChanged: (value) {
                  ref.read(forceOfflineProvider.notifier).state = value;
                  if (!value) {
                    ref.invalidate(postsProvider);
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('Belum ada data (coba online dulu 1x)'));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
              );
            },
          );
        },
      ),
    );
  }
}