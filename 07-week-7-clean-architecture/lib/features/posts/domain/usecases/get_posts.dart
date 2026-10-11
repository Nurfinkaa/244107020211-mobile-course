import '../../../../core/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  const GetPosts(this._repository);

  final PostRepository _repository;

  /// Cache-first: selalu baca cache dulu. Bila [refresh] true, fetch data
  /// baru dari jaringan; bila fetch gagal, cache lama tetap dipakai.
  Future<({List<Post> posts, Failure? failure})> call({
    bool refresh = true,
  }) async {
    final cached = await _repository.readCachedPosts();
    if (cached.failure != null) {
      return (posts: const <Post>[], failure: cached.failure);
    }
    if (!refresh) return (posts: cached.posts, failure: null);

    final fresh = await _repository.fetchAndCachePosts();
    if (fresh.failure != null) {
      return (posts: cached.posts, failure: fresh.failure);
    }
    return (posts: fresh.posts, failure: null);
  }
}
