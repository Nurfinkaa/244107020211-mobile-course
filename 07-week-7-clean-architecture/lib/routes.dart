import 'package:go_router/go_router.dart';

import 'core/format.dart';
import 'features/notes/presentation/pages/note_detail_page.dart';
import 'features/notes/presentation/pages/notes_page.dart';
import 'pages/posts_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesPage(),
    ),
    GoRoute(
      path: '/note/:id',
      builder: (context, state) {
        final id = parseNoteId(state.pathParameters['id']);
        if (id == null) return const NotesPage();
        return NoteDetailPage(noteId: id);
      },
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) => const PostsPage(),
    ),
  ],
);
