import 'package:flutter_test/flutter_test.dart';
import 'package:week5_offline_notes/features/notes/data/models/note_model.dart';

void main() {
  test('fromMap aman terhadap field yang hilang', () {
    final model = NoteModel.fromMap({'title': 'Belanja'});
    expect(model.title, 'Belanja');
    expect(model.body, '');
    expect(model.dirty, isFalse);
  });

  test('flag dirty bertahan pada serialisasi', () {
    final model = NoteModel(
      title: 'a',
      updatedAt: DateTime(2026, 9, 18),
      dirty: true,
    );
    final restored = NoteModel.fromMap(model.toMap());
    expect(restored.dirty, isTrue);
  });

  test('toEntity menghasilkan entity dengan field yang sama', () {
    final model = NoteModel(
      id: 7,
      title: 'Judul',
      body: 'Isi',
      updatedAt: DateTime(2026, 10, 11),
      dirty: true,
    );
    final entity = model.toEntity();
    expect(entity.id, 7);
    expect(entity.title, 'Judul');
    expect(entity.dirty, isTrue);
  });
}
