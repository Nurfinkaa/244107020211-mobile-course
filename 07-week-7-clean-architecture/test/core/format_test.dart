import 'package:flutter_test/flutter_test.dart';
import 'package:week5_offline_notes/core/format.dart';

void main() {
  test('parseNoteId mengembalikan int untuk id valid', () {
    expect(parseNoteId('42'), 42);
  });

  test('parseNoteId mengembalikan null untuk input invalid', () {
    expect(parseNoteId('abc'), isNull);
    expect(parseNoteId(null), isNull);
    expect(parseNoteId(''), isNull);
  });

  test('label teks sesuai status dirty', () {
    expect(dirtyBadgeLabel(3), '3 belum sync');
    expect(noteStatusLabel(true), 'Status: belum tersinkron');
    expect(noteStatusLabel(false), 'Status: tersinkron');
  });
}
