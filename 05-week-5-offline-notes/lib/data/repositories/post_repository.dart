import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../local/db.dart';
import '../local/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PostRepository {
  PostRepository({Future<Database> Function()? openDb, Dio? dio})
      : _openDb = openDb ?? openNotesDb,
        _dio = dio ?? Dio();

  final Future<Database> Function() _openDb;
  final Dio _dio;

  /// 1. Baca cache lokal dari tabel cached_posts
  Future<List<Post>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts', orderBy: 'id ASC');
    return rows.map((row) {
      final payload = jsonDecode(row['payload'] as String) as Map<String, dynamic>;
      return Post.fromJson(payload);
    }).toList();
  }

  /// 2. Simpan hasil fetch API ke cached_posts (replace semua)
  Future<void> _savePostsToCache(List<Post> posts) async {
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

  /// 3. Fetch dari API (JSONPlaceholder), lalu simpan ke cache
  Future<List<Post>> fetchAndCachePosts() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
    final data = response.data as List;
    final posts = data
        .take(20) // ambil 20 saja biar ringan
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
    await _savePostsToCache(posts);
    return posts;
  }
}