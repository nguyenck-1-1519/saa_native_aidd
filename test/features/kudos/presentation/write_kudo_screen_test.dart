import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/kudos/presentation/write_kudo_screen.dart';

/// Pump [WriteKudoScreen] in a [ProviderScope] + [MaterialApp] with optional callbacks.
Future<void> _pump(
  WidgetTester tester, {
  void Function(WriteKudoFormData)? onSubmit,
  VoidCallback? onCancel,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: WriteKudoScreen(onSubmit: onSubmit, onCancel: onCancel),
      ),
    ),
  );
}

/// Fill the "Người nhận" field.
Future<void> _fillRecipient(WidgetTester tester, String value) async {
  // The recipient search field is the first TextField (search-style).
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), value);
}

/// Fill the "Danh hiệu" field.
Future<void> _fillTitle(WidgetTester tester, String value) async {
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(1), value);
}

/// Fill the "Nội dung lời cám ơn" field.
Future<void> _fillMessage(WidgetTester tester, String value) async {
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(2), value);
}

/// Add a hashtag via the dialog.
Future<void> _addHashtag(WidgetTester tester, String tag) async {
  await tester.tap(find.text('Hashtag (Tối đa 5)', skipOffstage: false));
  await tester.pumpAndSettle();
  // Dialog textfield is the only one visible.
  await tester.enterText(find.byType(TextField).last, tag);
  await tester.tap(find.text('Thêm'));
  await tester.pumpAndSettle();
}

void main() {
  // -------------------------------------------------------------------------
  // Validation: empty submit shows required errors
  // -------------------------------------------------------------------------

  group('WriteKudoScreen — validation', () {
    testWidgets('Gửi đi with all empty fields shows required error messages',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester);
      await tester.tap(find.text('Gửi đi'));
      await tester.pumpAndSettle();

      expect(find.text('Vui lòng chọn người nhận'), findsOneWidget);
      expect(find.text('Vui lòng nhập danh hiệu'), findsOneWidget);
      expect(find.text('Vui lòng nhập nội dung lời cám ơn'), findsOneWidget);
      expect(find.text('Vui lòng thêm ít nhất 1 hashtag'), findsOneWidget);
    });

    testWidgets('recipient error disappears after typing in field',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester);
      await tester.tap(find.text('Gửi đi'));
      await tester.pumpAndSettle();

      expect(find.text('Vui lòng chọn người nhận'), findsOneWidget);

      await _fillRecipient(tester, 'Nguyễn Văn A');
      // Wait for the debounce timer (300ms) + extra buffer + any pending frames
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Vui lòng chọn người nhận'), findsNothing);
    });

    testWidgets('title at exactly 100 chars passes validation', (tester) async {
      // The title TextField enforces maxLength: 100 at input — 101-char entry
      // cannot be typed. Verify the boundary: exactly 100 chars is valid.
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      WriteKudoFormData? captured;
      await _pump(tester, onSubmit: (d) => captured = d);

      await _fillRecipient(tester, 'User');
      await _fillTitle(tester, 'A' * 100);
      await _fillMessage(tester, 'Valid message');
      await _addHashtag(tester, 'TestTag');

      await tester.tap(find.text('Gửi đi'));
      await tester.pumpAndSettle();

      // No title error — 100 chars is within limit.
      expect(find.text('Danh hiệu tối đa 100 ký tự'), findsNothing);
      expect(captured, isNotNull);
      expect(captured!.title.length, 100);
    });

    testWidgets('message at exactly 1000 chars passes validation',
        (tester) async {
      // The message textarea has maxLength: 1000 and _validate() rejects > 1000.
      // Exactly 1000 chars is valid.
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      WriteKudoFormData? captured;
      await _pump(tester, onSubmit: (d) => captured = d);

      await _fillRecipient(tester, 'User');
      await _fillTitle(tester, 'Title');
      await _fillMessage(tester, 'A' * 1000);
      await _addHashtag(tester, 'TestTag');

      // Scroll to Gửi đi and tap it.
      await tester.ensureVisible(find.text('Gửi đi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gửi đi'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Nội dung tối đa 1000 ký tự'), findsNothing);
      expect(captured, isNotNull);
      expect(captured!.message.length, 1000);
    });
  });

  // -------------------------------------------------------------------------
  // Valid submission
  // -------------------------------------------------------------------------

  group('WriteKudoScreen — valid submission', () {
    testWidgets(
        'Gửi đi with valid fields calls onSubmit with correct data',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      WriteKudoFormData? captured;
      await _pump(tester, onSubmit: (data) => captured = data);

      await _fillRecipient(tester, 'Trần Thị B');
      await _fillTitle(tester, 'Rising Hero');
      await _fillMessage(tester, 'Cảm ơn bạn!');
      await _addHashtag(tester, 'Teamwork');

      await tester.tap(find.text('Gửi đi'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.recipient, 'Trần Thị B');
      expect(captured!.title, 'Rising Hero');
      expect(captured!.message, 'Cảm ơn bạn!');
      expect(captured!.hashtags, contains('Teamwork'));
    });

    testWidgets('Gửi đi without onSubmit shows SnackBar and pops',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // Wrap in a Navigator so pop works.
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    ctx,
                    MaterialPageRoute<void>(
                      builder: (_) => const WriteKudoScreen(),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await _fillRecipient(tester, 'Someone');
      await _fillTitle(tester, 'Hero');
      await _fillMessage(tester, 'Thanks!');
      await _addHashtag(tester, 'Win');

      await tester.tap(find.text('Gửi đi'));
      await tester.pumpAndSettle();

      expect(find.text('Đã gửi Kudo'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Cancel
  // -------------------------------------------------------------------------

  group('WriteKudoScreen — cancel', () {
    testWidgets('Huỷ button calls onCancel callback', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      var cancelled = false;
      await _pump(tester, onCancel: () => cancelled = true);

      await tester.tap(find.text('Huỷ'));
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // Hashtag chip add/remove + cap at 5
  // -------------------------------------------------------------------------

  group('WriteKudoScreen — hashtag chips', () {
    testWidgets('added hashtag appears as a chip', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester);
      await _addHashtag(tester, 'MyTag');

      expect(find.text('#MyTag'), findsOneWidget);
    });

    testWidgets('removing a chip removes it from the list', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester);
      await _addHashtag(tester, 'RemoveMe');
      expect(find.text('#RemoveMe'), findsOneWidget);

      // Tap the close icon on the chip.
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      expect(find.text('#RemoveMe'), findsNothing);
    });

    testWidgets('add button hidden after 5 hashtags are added', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester);
      for (var i = 1; i <= 5; i++) {
        await _addHashtag(tester, 'Tag$i');
      }

      // "Hashtag (Tối đa 5)" add button should be gone once cap reached.
      expect(find.text('Hashtag (Tối đa 5)'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // No RenderFlex overflow at 375px width
  // -------------------------------------------------------------------------

  group('WriteKudoScreen — no overflow', () {
    testWidgets('renders without RenderFlex overflow at 375px logical width',
        (tester) async {
      // 375×812 logical (1125×2436 @3x) — iPhone SE viewport.
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final overflowErrors = <String>[];
      final savedOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        final msg = details.toString();
        if (msg.contains('RenderFlex overflowed')) {
          overflowErrors.add(msg);
        } else {
          savedOnError?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = savedOnError);

      await _pump(tester);
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'WriteKudoScreen must not overflow at 375px logical width');
    });

    testWidgets('renders without overflow after adding a hashtag at 375px',
        (tester) async {
      tester.view.physicalSize = const Size(1125, 2436);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final overflowErrors = <String>[];
      final savedOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        final msg = details.toString();
        if (msg.contains('RenderFlex overflowed')) {
          overflowErrors.add(msg);
        } else {
          savedOnError?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = savedOnError);

      await _pump(tester);
      await _addHashtag(tester, 'NoOverflow');
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'No overflow after hashtag added');
    });
  });
}
