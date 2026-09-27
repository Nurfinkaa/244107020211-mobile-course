PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter analyze lib/pages/notes_page.dart
Analyzing notes_page.dart...                                            
No issues found! (ran in 57.5s)
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter analyze
Analyzing 05-week-5-offline-notes...                                    

warning - Unused import: 'package:flutter_riverpod/flutter_riverpod.dart'. Try removing the import directive - lib\data\network_state.dart:1:8 - unused_import
warning - Unused import: 'package:flutter_riverpod/flutter_riverpod.dart'. Try removing the import directive - lib\data\repositories\post_repository.dart:6:8 - unused_import
warning - Unused import: 'package:flutter/material.dart'. Try removing the import directive - lib\pages\settings_page.dart:1:8 - unused_import
  error - Undefined name 'noteRepositoryProvider'. Try correcting the name to one that is defined, or defining the name - test\note_test.dart:45:9 - undefined_identifier
  error - Undefined name 'notesProvider'. Try correcting the name to one that is defined, or defining the name - test\note_test.dart:53:40 - undefined_identifier
  error - The property 'length' can't be unconditionally accessed because the receiver can be 'null'. Try making the access conditional (using '?.') or adding a null check to the target ('!') -
         test\note_test.dart:54:18 - unchecked_use_of_nullable_value
  error - The property 'first' can't be unconditionally accessed because the receiver can be 'null'. Try making the access conditional (using '?.') or adding a null check to the target ('!') -
         test\note_test.dart:55:18 - unchecked_use_of_nullable_value
  error - Undefined name 'noteRepositoryProvider'. Try correcting the name to one that is defined, or defining the name - test\note_test.dart:61:9 - undefined_identifier
  error - Undefined name 'notesProvider'. Try correcting the name to one that is defined, or defining the name - test\note_test.dart:68:22 - undefined_identifier

9 issues found. (ran in 11.3s)
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter analyze                          
Analyzing 05-week-5-offline-notes...                                    

warning - Unused import: 'package:flutter_riverpod/flutter_riverpod.dart'. Try removing the import directive - lib\data\network_state.dart:1:8 - unused_import
warning - Unused import: 'package:flutter_riverpod/flutter_riverpod.dart'. Try removing the import directive - lib\data\repositories\post_repository.dart:6:8 - unused_import
warning - Unused import: 'package:flutter/material.dart'. Try removing the import directive - lib\pages\settings_page.dart:1:8 - unused_import

3 issues found. (ran in 9.2s)
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter analyze
Analyzing 05-week-5-offline-notes...                                    
No issues found! (ran in 13.5s)
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test   
00:45 +3: D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/widget_test.dart: Counter increments smoke test                                                   
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following StateError was thrown building NotesPage(dirty, state: _ConsumerState#9b07e):
Bad state: No ProviderScope found

The relevant error-causing widget was:
  NotesPage
  NotesPage:file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/lib/main.dart:19:42

When the exception was thrown, this was the stack:
#0      ProviderScope.containerOf (package:flutter_riverpod/src/core/provider_scope.dart:105:7)
#1      ConsumerStatefulElement.container (package:flutter_riverpod/src/core/consumer.dart:374:52)
#2      ConsumerStatefulElement.container (package:flutter_riverpod/src/core/consumer.dart)
#3      ConsumerStatefulElement.watch.<anonymous closure> (package:flutter_riverpod/src/core/consumer.dart:490:27)
#4      _LinkedHashMapMixin.putIfAbsent (dart:_compact_hash:631:23)
#5      ConsumerStatefulElement.watch (package:flutter_riverpod/src/core/consumer.dart:483:14)
#6      NotesPage.build (package:week5_offline_notes/pages/notes_page.dart:45:28)
#7      _ConsumerState.build (package:flutter_riverpod/src/core/consumer.dart:283:48)
#8      StatefulElement.build (package:flutter/src/widgets/framework.dart:5944:27)
#9      ConsumerStatefulElement.build (package:flutter_riverpod/src/core/consumer.dart:460:20)
#10     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5830:15)
#11     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5995:11)
#12     Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#13     ComponentElement._firstBuild (package:flutter/src/widgets/framework.dart:5812:5)
#14     StatefulElement._firstBuild (package:flutter/src/widgets/framework.dart:5986:11)
#15     ComponentElement.mount (package:flutter/src/widgets/framework.dart:5806:5)
#16     ConsumerStatefulElement.mount (package:flutter_riverpod/src/core/consumer.dart:389:11)
...     Normal element mounting (166 frames)
#182    Element.inflateWidget (package:flutter/src/widgets/framework.dart:4600:20)
#183    MultiChildRenderObjectElement.inflateWidget (package:flutter/src/widgets/framework.dart:7277:36)
#184    MultiChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:7292:32)
...     Normal element mounting (508 frames)
#692    Element.inflateWidget (package:flutter/src/widgets/framework.dart:4600:20)
#693    Element.updateChild (package:flutter/src/widgets/framework.dart:4066:20)
#694    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#695    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#696    ProxyElement.update (package:flutter/src/widgets/framework.dart:6162:5)
#697    _InheritedNotifierElement.update (package:flutter/src/widgets/inherited_notifier.dart:108:11)
#698    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#699    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#700    StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5995:11)
#701    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#702    StatefulElement.update (package:flutter/src/widgets/framework.dart:6020:5)
#703    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#704    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#705    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#706    ProxyElement.update (package:flutter/src/widgets/framework.dart:6162:5)
#707    _InheritedNotifierElement.update (package:flutter/src/widgets/inherited_notifier.dart:108:11)
#708    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#709    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#710    StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5995:11)
#711    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#712    StatefulElement.update (package:flutter/src/widgets/framework.dart:6020:5)
#713    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#714    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#715    StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5995:11)
#716    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#717    StatefulElement.update (package:flutter/src/widgets/framework.dart:6020:5)
#718    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#719    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#720    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#721    ProxyElement.update (package:flutter/src/widgets/framework.dart:6162:5)
#722    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#723    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#724    StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5995:11)
#725    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#726    StatefulElement.update (package:flutter/src/widgets/framework.dart:6020:5)
#727    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#728    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#729    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#730    ProxyElement.update (package:flutter/src/widgets/framework.dart:6162:5)
#731    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#732    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#733    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#734    ProxyElement.update (package:flutter/src/widgets/framework.dart:6162:5)
#735    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#736    _RawViewElement._updateChild (package:flutter/src/widgets/view.dart:488:16)
#737    _RawViewElement.update (package:flutter/src/widgets/view.dart:575:5)
#738    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#739    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#740    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#741    StatelessElement.update (package:flutter/src/widgets/framework.dart:5908:5)
#742    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#743    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5854:16)
#744    StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5995:11)
#745    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#746    StatefulElement.update (package:flutter/src/widgets/framework.dart:6020:5)
#747    Element.updateChild (package:flutter/src/widgets/framework.dart:4050:15)
#748    RootElement._rebuild (package:flutter/src/widgets/binding.dart:2091:16)
#749    RootElement.update (package:flutter/src/widgets/binding.dart:2069:5)
#750    RootElement.performRebuild (package:flutter/src/widgets/binding.dart:2083:7)
#751    Element.rebuild (package:flutter/src/widgets/framework.dart:5542:7)
#752    BuildScope._tryRebuild (package:flutter/src/widgets/framework.dart:2763:15)
#753    BuildScope._flushDirtyElements (package:flutter/src/widgets/framework.dart:2820:11)
#754    BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:3124:18)
#755    AutomatedTestWidgetsFlutterBinding.drawFrame (package:flutter_test/src/binding.dart:2432:19)
#756    RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:558:5)
#757    SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1430:15)
#758    SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1345:9)
#759    AutomatedTestWidgetsFlutterBinding.pump.<anonymous closure> (package:flutter_test/src/binding.dart:2261:9)
#762    TestAsyncUtils.guard (package:flutter_test/src/test_async_utils.dart:74:41)
#763    AutomatedTestWidgetsFlutterBinding.pump (package:flutter_test/src/binding.dart:2250:27)
#764    WidgetTester.pumpWidget.<anonymous closure> (package:flutter_test/src/widget_tester.dart:598:22)
#767    TestAsyncUtils.guard (package:flutter_test/src/test_async_utils.dart:74:41)
#768    WidgetTester.pumpWidget (package:flutter_test/src/widget_tester.dart:595:27)
#769    main.<anonymous closure> (file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/widget_test.dart:16:18)
#770    testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:192:29)
<asynchronous suspension>
#771    TestWidgetsFlutterBinding._runTestBody (package:flutter_test/src/binding.dart:1953:5)
<asynchronous suspension>
<asynchronous suspension>
(elided 5 frames from dart:async and package:stack_trace)

════════════════════════════════════════════════════════════════════════════════════════════════════
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found 0 widgets with text "0": []>
   Which: means none were found but one was expected

When the exception was thrown, this was the stack:
#4      main.<anonymous closure> (file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/widget_test.dart:19:5)
<asynchronous suspension>
#5      testWidgets.<anonymous closure>.<anonymous closure> (package:flutter_test/src/widget_tester.dart:192:15)
<asynchronous suspension>
#6      TestWidgetsFlutterBinding._runTestBody (package:flutter_test/src/binding.dart:1953:5)
<asynchronous suspension>
<asynchronous suspension>
(elided one frame from package:stack_trace)

This was caught by the test expectation on the following line:
  file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/widget_test.dart line 19
The test description was:
  Counter increments smoke test
════════════════════════════════════════════════════════════════════════════════════════════════════
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following message was thrown:
Multiple exceptions (2) were detected during the running of the current test, and at least one was
unexpected.
════════════════════════════════════════════════════════════════════════════════════════════════════
00:45 +3 -1: D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/widget_test.dart: Counter increments smoke test [E]                                            
  Test failed. See exception logs above.
  The test description was: Counter increments smoke test
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/widget_test.dart -p vm --plain-name "Counter increments smoke test"
01:13 +3 -2: D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart: provider error dengan repository palsu [E]                                     
  TimeoutException after 0:00:30.000000: Test timed out after 30 seconds. See https://pub.dev/packages/test#timeouts
  dart:isolate  _RawReceivePort._handleMessage
  
  Expected: throws <Instance of 'Exception'>
    Actual: <Instance of 'Future<List<Note>>'>
     Which: threw StateError:<Bad state: The provider AsyncNotifierProvider<NotesNotifier, List<Note>>#726de was disposed during loading state, yet no value could be emitted.>
            stack package:riverpod/src/core/element.dart 341:70              ElementWithFuture.dispose
                  package:riverpod/src/core/provider_container.dart 1317:15  ProviderContainer._dispose
                  package:riverpod/src/core/provider_container.dart 1335:21  ProviderContainer.dispose
                  ===== asynchronous gap ===========================
                  dart:async                                                 _Completer.completeError
                  package:riverpod/src/core/element.dart 341:19              ElementWithFuture.dispose
                  package:riverpod/src/core/provider_container.dart 1317:15  ProviderContainer._dispose
                  package:riverpod/src/core/provider_container.dart 1335:21  ProviderContainer.dispose
                  
            which is not an instance of 'Exception'
  
  package:matcher                                    expectLater
  package:flutter_test/src/widget_tester.dart 507:8  expectLater
  test\note_test.dart 68:11                          main.<fn>
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart -p vm --plain-name "provider error dengan repository palsu"
01:13 +3 -2: Some tests failed.                                                                                                                                                                              
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> del test\widget_test.dart
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test 
00:36 +3 -1: provider error dengan repository palsu [E]                                                                                                                                                      
  TimeoutException after 0:00:30.000000: Test timed out after 30 seconds. See https://pub.dev/packages/test#timeouts
  dart:isolate  _RawReceivePort._handleMessage
  
  Expected: throws <Instance of 'Exception'>
    Actual: <Instance of 'Future<List<Note>>'>
     Which: threw StateError:<Bad state: The provider AsyncNotifierProvider<NotesNotifier, List<Note>>#6e89c was disposed during loading state, yet no value could be emitted.>
            stack package:riverpod/src/core/element.dart 341:70              ElementWithFuture.dispose
                  package:riverpod/src/core/provider_container.dart 1317:15  ProviderContainer._dispose
                  package:riverpod/src/core/provider_container.dart 1335:21  ProviderContainer.dispose
                  ===== asynchronous gap ===========================
                  dart:async                                                 _Completer.completeError
                  package:riverpod/src/core/element.dart 341:19              ElementWithFuture.dispose
                  package:riverpod/src/core/provider_container.dart 1317:15  ProviderContainer._dispose
                  package:riverpod/src/core/provider_container.dart 1335:21  ProviderContainer.dispose
                  
            which is not an instance of 'Exception'
  
  package:matcher                                    expectLater
  package:flutter_test/src/widget_tester.dart 507:8  expectLater
  test\note_test.dart 68:11                          main.<fn>
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart -p vm --plain-name "provider error dengan repository palsu"
00:36 +3 -1: Some tests failed.                                                                                                                                                                              
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test 
01:02 +3 -1: provider error dengan repository palsu [E]                                                                                                                                                      
  TimeoutException after 0:00:30.000000: Test timed out after 30 seconds. See https://pub.dev/packages/test#timeouts
  dart:isolate  _RawReceivePort._handleMessage
  
  Invalid argument(s) (onError): The error handler of Future.catchError must return a value of the future's type
  dart:async  _startMicrotaskLoop
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart -p vm --plain-name "provider error dengan repository palsu"
01:02 +3 -1: Some tests failed.                                                                                                                                                                              
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test 
00:35 +3 -1: provider error dengan repository palsu [E]                                                                                                                                                      
  TimeoutException after 0:00:30.000000: Test timed out after 30 seconds. See https://pub.dev/packages/test#timeouts
  dart:isolate  _RawReceivePort._handleMessage
  
  Bad state: Tried to read a provider from a ProviderContainer that was already disposed
  package:riverpod/src/core/provider_container.dart 1285:7   ProviderContainer._readProviderElement
  package:riverpod/src/core/provider_container.dart 854:8    ContainerReadElement.readProviderElement
  package:riverpod/src/core/provider/provider.dart 117:38    $ProviderBaseImpl._addListener
  package:riverpod/src/core/provider_container.dart 1141:26  ProviderContainer.listen
  package:riverpod/src/core/provider_container.dart 1068:17  ProviderContainer.read
  test\note_test.dart 80:22                                  main.<fn>
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart -p vm --plain-name "provider error dengan repository palsu"
00:35 +3 -1: Some tests failed.                                                                                                                                                                              
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test 
00:27 +3 -1: provider error dengan repository palsu [E]                                                                                                                                                      
  Expected: <Instance of 'AsyncError'>
    Actual: AsyncLoading<List<Note>>:<AsyncLoading<List<Note>>(error: Exception: db locked (simulasi), stackTrace: #0      FakeNoteRepository.fetchNotes (file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart:16:21)
            #1      NotesNotifier.build (package:week5_offline_notes/pages/notes_page.dart:20:41)
            #2      ElementWithFuture.handleFuture.<anonymous closure> (package:riverpod/src/core/element.dart:218:30)
            #3      ElementWithFuture._handleAsync (package:riverpod/src/core/element.dart:282:35)
            #4      ElementWithFuture.handleFuture (package:riverpod/src/core/element.dart:212:12)
            #5      $AsyncNotifierProviderElement.handleCreate (package:riverpod/src/providers/async_notifier.dart:91:12)
            #6      AsyncNotifier.runBuild (package:riverpod/src/providers/async_notifier/orphan.dart:37:47)
            #7      $ClassProviderElement.create (package:riverpod/src/core/provider/notifier_provider.dart:570:43)
            #8      ProviderElement.buildState (package:riverpod/src/core/element.dart:751:28)
            #9      ProviderElement.mount (package:riverpod/src/core/element.dart:587:7)
            #10     ProviderElement.flush (package:riverpod/src/core/element.dart:704:9)
            #11     $ProviderBaseImpl._addListener (package:riverpod/src/core/provider/provider.dart:119:24)
            #12     ProviderContainer.listen (package:riverpod/src/core/provider_container.dart:1141:26)
            #13     main.<anonymous closure> (file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart:72:15)
            #14     Declarer.test.<anonymous closure>.<anonymous closure> (package:test_api/src/backend/declarer.dart:253:25)
            <asynchronous suspension>
            #15     Declarer.test.<anonymous closure> (package:test_api/src/backend/declarer.dart:250:11)
            <asynchronous suspension>
            #16     Invoker._waitForOutstandingCallbacks.<anonymous closure> (package:test_api/src/backend/invoker.dart:318:9)
            <asynchronous suspension>
            , retrying)>
     Which: is not an instance of 'AsyncError'
  
  package:matcher                                     expect
  package:flutter_test/src/widget_tester.dart 473:18  expect
  test\note_test.dart 77:5                            main.<fn>
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart -p vm --plain-name "provider error dengan repository palsu"
00:27 +3 -1: Some tests failed.                                                                                                                                                                              
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test 
00:06 +3 -1: provider error dengan repository palsu [E]                                                                                                                                                      
  Expected: <Instance of 'AsyncError'>
    Actual: AsyncLoading<List<Note>>:<AsyncLoading<List<Note>>(error: Exception: db locked (simulasi), stackTrace: #0      FakeNoteRepository.fetchNotes (file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart:16:21)
            #1      NotesNotifier.build (package:week5_offline_notes/pages/notes_page.dart:20:41)
            #2      ElementWithFuture.handleFuture.<anonymous closure> (package:riverpod/src/core/element.dart:218:30)
            #3      ElementWithFuture._handleAsync (package:riverpod/src/core/element.dart:282:35)
            #4      ElementWithFuture.handleFuture (package:riverpod/src/core/element.dart:212:12)
            #5      $AsyncNotifierProviderElement.handleCreate (package:riverpod/src/providers/async_notifier.dart:91:12)
            #6      AsyncNotifier.runBuild (package:riverpod/src/providers/async_notifier/orphan.dart:37:47)
            #7      $ClassProviderElement.create (package:riverpod/src/core/provider/notifier_provider.dart:570:43)
            #8      ProviderElement.buildState (package:riverpod/src/core/element.dart:751:28)
            #9      ProviderElement.mount (package:riverpod/src/core/element.dart:587:7)
            #10     ProviderElement.flush (package:riverpod/src/core/element.dart:704:9)
            #11     $ProviderBaseImpl._addListener (package:riverpod/src/core/provider/provider.dart:119:24)
            #12     ProviderContainer.listen (package:riverpod/src/core/provider_container.dart:1141:26)
            #13     main.<anonymous closure> (file:///D:/Kuliah/!Semester%205/Pemrograman%20Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart:72:15)
            #14     Declarer.test.<anonymous closure>.<anonymous closure> (package:test_api/src/backend/declarer.dart:253:25)
            <asynchronous suspension>
            #15     Declarer.test.<anonymous closure> (package:test_api/src/backend/declarer.dart:250:11)
            <asynchronous suspension>
            #16     Invoker._waitForOutstandingCallbacks.<anonymous closure> (package:test_api/src/backend/invoker.dart:318:9)
            <asynchronous suspension>
            , retrying)>
     Which: is not an instance of 'AsyncError'
  
  package:matcher                                     expect
  package:flutter_test/src/widget_tester.dart 473:18  expect
  test\note_test.dart 77:5                            main.<fn>
  

To run this test again: C:\src\flutter\bin\cache\dart-sdk\bin\dart.exe test D:/Kuliah/!Semester 5/Pemrograman Mobile/244107020211-mobile-course/05-week-5-offline-notes/test/note_test.dart -p vm --plain-name "provider error dengan repository palsu"
00:06 +3 -1: Some tests failed.                                                                                                                                                                              
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> flutter test 
00:06 +4: All tests passed!                                                                                                                                                                                  
PS D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\05-week-5-offline-notes> 
