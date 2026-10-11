import 'package:flutter_test/flutter_test.dart';
import 'package:week5_offline_notes/core/failures.dart';
import 'package:week5_offline_notes/features/posts/domain/entities/post.dart';
import 'package:week5_offline_notes/features/posts/domain/repositories/post_repository.dart';
import 'package:week5_offline_notes/features/posts/domain/usecases/get_posts.dart';

class FakePostRepository implements PostRepository {
  FakePostRepository({
    this.cached = const [],
    this.fresh = const [],
    this.fetchFailure,
  });

  final List<Post> cached;
  final List<Post> fresh;
  final Failure? fetchFailure;
  bool fetchCalled = false;

  @override
  Future<({List<Post> posts, Failure? failure})> readCachedPosts() async =>
      (posts: cached, failure: null);

  @override
  Future<({List<Post> posts, Failure? failure})> fetchAndCachePosts() async {
    fetchCalled = true;
    if (fetchFailure != null) {
      return (posts: const <Post>[], failure: fetchFailure);
    }
    return (posts: fresh, failure: null);
  }
}

void main() {
  test('GetPosts refresh mengembalikan data baru saat fetch sukses', () async {
    final repo = FakePostRepository(
      cached: [const Post(id: 1, title: 'lama', body: 'a')],
      fresh: [const Post(id: 2, title: 'baru', body: 'b')],
    );
    final result = await GetPosts(repo).call();
    expect(result.failure, isNull);
    expect(result.posts.single.title, 'baru');
  });

  test('GetPosts tetap memakai cache saat fetch gagal', () async {
    final repo = FakePostRepository(
      cached: [const Post(id: 1, title: 'lama', body: 'a')],
      fetchFailure: const NetworkFailure('no connection'),
    );
    final result = await GetPosts(repo).call();
    expect(result.failure, isA<NetworkFailure>());
    expect(result.posts.single.title, 'lama');
  });

  test('GetPosts refresh=false tidak menyentuh jaringan', () async {
    final repo = FakePostRepository(
      cached: [const Post(id: 1, title: 'lama', body: 'a')],
      fresh: [const Post(id: 2, title: 'baru', body: 'b')],
    );
    final result = await GetPosts(repo).call(refresh: false);
    expect(result.failure, isNull);
    expect(result.posts.single.title, 'lama');
    expect(repo.fetchCalled, isFalse);
  });
}
