import '../../../../core/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<({List<Post> posts, Failure? failure})> readCachedPosts();
  Future<({List<Post> posts, Failure? failure})> fetchAndCachePosts();
}
