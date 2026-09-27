import 'package:hive/hive.dart';

class NoteHive extends HiveObject {
  String title;
  String body;
  bool dirty;

  NoteHive({required this.title, required this.body, this.dirty = true});
}