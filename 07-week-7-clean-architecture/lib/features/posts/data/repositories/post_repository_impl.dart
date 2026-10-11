import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/failures.dart';
import '../../../notes/data/local/db.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({Future<Database> Function()? openDb, Dio? dio})
      : _openDb = openDb ?? openNotesDb,
        _dio = dio ?? Dio();

  final Future<Database> Function() _openDb;
  final Dio _dio;

  @override
  Future<({List<Post> posts, Failure? failure})> readCachedPosts() async {
    try {
      final db = await _openDb();
      final rows = await db.query('cached_posts', orderBy: 'id ASC');
      final posts = rows.map((row) {
        final payload = jsonDecode(row['payload'] as String) as Map<String, dynamic>;
        return PostModel.fromJson(payload).toEntity();
      }).toList();
      return (posts: posts, failure: null);
    } catch (e) {
      return (
        posts: const <Post>[],
        failure: LocalFailure('Gagal membaca cache posts: $e'),
      );
    }
  }

  @override
  Future<({List<Post> posts, Failure? failure})> fetchAndCachePosts() async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts');
      final data = response.data as List;
      final posts = data
          .take(20) // ambil 20 saja biar ringan
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList();
      await _savePostsToCache(posts);
      return (posts: posts.map((m) => m.toEntity()).toList(), failure: null);
    } on DioException catch (e) {
      return (
        posts: const <Post>[],
        failure: NetworkFailure('Gagal mengambil posts dari jaringan: $e'),
      );
    } catch (e) {
      return (
        posts: const <Post>[],
        failure: LocalFailure('Gagal menyimpan cache posts: $e'),
      );
    }
  }

  Future<void> _savePostsToCache(List<PostModel> posts) async {
    final db = await _openDb();
    final now = DateTime.now().toIso8601String();
    final batch = db.batch();
    batch.delete('cached_posts'); // bersihkan cache lama
    for (final post in posts) {
      batch.insert('cached_posts', {
        'id': post.id,
        'payload': jsonEncode(post.toJson()),
        'cached_at': now,
      });
    }
    await batch.commit(noResult: true);
  }
}
