import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/post.dart';
import '../data/network_errors.dart';
import '../data/providers.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.postId, this.initialPost});

  final int postId;
  final Post? initialPost;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  late Future<Post> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.initialPost != null
        ? Future.value(widget.initialPost)
        : _fetchById(widget.postId);
  }

  Future<Post> _fetchById(int id) async {
    final repository = ref.read(postRepositoryProvider);
    final posts = await repository.fetchPosts();
    return posts.firstWhere((p) => p.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post #${widget.postId}')),
      body: FutureBuilder<Post>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(friendlyErrorMessage(snapshot.error!)));
          }
          final post = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(post.body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
