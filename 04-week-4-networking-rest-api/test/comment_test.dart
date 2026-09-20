import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/comment.dart';

void main() {
  test('fromJson aman terhadap field yang hilang', () {
    final comment = Comment.fromJson({'id': 5});
    expect(comment.id, 5);
    expect(comment.postId, 0);
    expect(comment.name, '');
    expect(comment.email, '');
    expect(comment.body, '');
  });

  // Edge case tambahan (bukan cuma happy path): tipe field yang salah
  // (postId dikirim sebagai String, bukan num) tidak boleh membuat
  // app crash — harus fallback ke default, bukan lempar exception.
  test('fromJson aman terhadap tipe field yang salah', () {
    final comment = Comment.fromJson({
      'postId': 'bukan-angka',
      'id': 5,
      'name': 123,
    });
    expect(comment.postId, 0);
    expect(comment.name, '');
  });
}