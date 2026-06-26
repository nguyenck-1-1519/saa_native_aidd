import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/notifications/presentation/widgets/notifications_mark_all_button.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildButton({double width = 375, VoidCallback? onTap}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('vi'),
    home: Scaffold(
      body: SizedBox(
        width: width,
        child: NotificationsMarkAllButton(onTap: onTap),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('NotificationsMarkAllButton', () {
    // -------------------------------------------------------------------------
    // Overflow — no RenderFlex overflow at 375pt (common iPhone width)
    // -------------------------------------------------------------------------

    testWidgets('renders without overflow at 375pt width', (tester) async {
      // Suppress overflow exceptions so the test fails on OUR assertion,
      // not Flutter's built-in overflow widget.
      final List<FlutterErrorDetails> overflowErrors = [];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('RenderFlex overflowed')) {
          overflowErrors.add(details);
        } else {
          originalOnError?.call(details);
        }
      };

      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      await tester.pumpWidget(_buildButton(width: 375));
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'NotificationsMarkAllButton must not overflow at 375pt. '
              'Wrap the Text in Flexible so it ellipsizes.');
    });

    testWidgets('renders without overflow at 320pt (iPhone SE) width',
        (tester) async {
      final List<FlutterErrorDetails> overflowErrors = [];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('RenderFlex overflowed')) {
          overflowErrors.add(details);
        } else {
          originalOnError?.call(details);
        }
      };

      addTearDown(() {
        FlutterError.onError = originalOnError;
      });

      await tester.pumpWidget(_buildButton(width: 320));
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'NotificationsMarkAllButton must not overflow at 320pt.');
    });

    // -------------------------------------------------------------------------
    // Tap callback
    // -------------------------------------------------------------------------

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_buildButton(onTap: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NotificationsMarkAllButton));
      expect(tapped, isTrue);
    });

    testWidgets('does not crash when onTap is null', (tester) async {
      await tester.pumpWidget(_buildButton());
      await tester.pumpAndSettle();

      // Should not throw.
      await tester.tap(find.byType(NotificationsMarkAllButton));
    });

    // -------------------------------------------------------------------------
    // Content
    // -------------------------------------------------------------------------

    testWidgets('shows the mark-all-read label text', (tester) async {
      await tester.pumpWidget(_buildButton());
      await tester.pumpAndSettle();

      // Vietnamese l10n string for notificationsMarkAllRead.
      expect(find.text('Đánh dấu tất cả đã đọc'), findsOneWidget);
    });

    testWidgets('shows the leading icon', (tester) async {
      await tester.pumpWidget(_buildButton());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.format_list_bulleted), findsOneWidget);
    });
  });
}
