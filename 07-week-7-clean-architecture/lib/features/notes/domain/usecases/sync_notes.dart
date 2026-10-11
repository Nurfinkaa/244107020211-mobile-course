import '../../../../core/failures.dart';
import '../repositories/note_repository.dart';

class SyncNotes {
  const SyncNotes(this._repository, {this.uploadDelay = const Duration(seconds: 1)});

  final NoteRepository _repository;

  /// Simulasi durasi upload ke server. Dapat di-injeksi Duration.zero saat test.
  final Duration uploadDelay;

  Future<({int synced, Failure? failure})> call() async {
    final dirty = await _repository.countDirty();
    if (dirty.failure != null) return (synced: 0, failure: dirty.failure);
    if (dirty.count == 0) return (synced: 0, failure: null);

    await Future.delayed(uploadDelay);
    final marked = await _repository.markAllSynced();
    if (marked.failure != null) return (synced: 0, failure: marked.failure);

    return (synced: dirty.count, failure: null);
  }
}
