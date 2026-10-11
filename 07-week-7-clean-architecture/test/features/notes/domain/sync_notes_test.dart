import 'package:flutter_test/flutter_test.dart';
import 'package:week5_offline_notes/core/failures.dart';
import 'package:week5_offline_notes/features/notes/domain/entities/note.dart';
import 'package:week5_offline_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:week5_offline_notes/features/notes/domain/usecases/sync_notes.dart';

class FakeSyncRepository implements NoteRepository {
  FakeSyncRepository({this.dirtyCount = 0, this.failure});

  final int dirtyCount;
  final Failure? failure;
  bool markAllSyncedCalled = false;

  @override
  Future<({int count, Failure? failure})> countDirty() async =>
      (count: dirtyCount, failure: failure);

  @override
  Future<({bool ok, Failure? failure})> markAllSynced() async {
    markAllSyncedCalled = true;
    return (ok: failure == null, failure: failure);
  }

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() =>
      throw UnimplementedError();

  @override
  Future<({Note? note, Failure? failure})> fetchNoteById(int id) =>
      throw UnimplementedError();

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) =>
      throw UnimplementedError();

  @override
  Future<({bool ok, Failure? failure})> deleteNote(int id) =>
      throw UnimplementedError();
}

void main() {
  test('SyncNotes menandai tersinkron dan melaporkan jumlah yang disinkronkan',
      () async {
    final repo = FakeSyncRepository(dirtyCount: 2);
    final result = await SyncNotes(repo, uploadDelay: Duration.zero).call();
    expect(result.failure, isNull);
    expect(result.synced, 2);
    expect(repo.markAllSyncedCalled, isTrue);
  });

  test('SyncNotes melewati markAllSynced saat tidak ada catatan dirty',
      () async {
    final repo = FakeSyncRepository(dirtyCount: 0);
    final result = await SyncNotes(repo, uploadDelay: Duration.zero).call();
    expect(result.failure, isNull);
    expect(result.synced, 0);
    expect(repo.markAllSyncedCalled, isFalse);
  });

  test('SyncNotes meneruskan failure tanpa melempar', () async {
    final repo =
        FakeSyncRepository(dirtyCount: 3, failure: const LocalFailure('db error'));
    final result = await SyncNotes(repo, uploadDelay: Duration.zero).call();
    expect(result.failure, isA<LocalFailure>());
    expect(result.synced, 0);
    expect(repo.markAllSyncedCalled, isFalse);
  });
}
