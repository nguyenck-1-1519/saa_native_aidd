import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';
import 'package:saa_2025/features/secret_box/domain/value_objects/secret_box_phase.dart';
import 'package:saa_2025/features/secret_box/presentation/providers/secret_box_providers.dart';

ProviderContainer _container({
  FakeSecretBoxRepository? secretBox,
}) {
  return ProviderContainer(
    overrides: [
      secretBoxRepositoryProvider
          .overrideWithValue(secretBox ?? FakeSecretBoxRepository.empty()),
    ],
  );
}

/// Helper: drive the full open → animation-complete flow.
///
/// open() is now synchronous (sets phase to opening); the draw happens in
/// onOpeningComplete() once the animation fires.
Future<void> _openAndComplete(SecretBoxController ctrl) async {
  ctrl.open();
  await ctrl.onOpeningComplete();
}

void main() {
  group('SecretBoxController', () {
    group('state machine', () {
      test('starts in closed phase', () {
        final container = _container();
        addTearDown(container.dispose);

        final state = container.read(secretBoxControllerProvider);

        expect(state.phase, equals(SecretBoxPhase.closed));
        expect(state.reward, isNull);
        expect(state.errorMessage, isNull);
      });

      test('open() transitions closed → opening synchronously', () {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Seed the count so open() does not guard against 0.
        container.read(secretBoxControllerProvider.notifier)
            // ignore: invalid_use_of_protected_member
            .state = container
                .read(secretBoxControllerProvider)
                .copyWith(unopenedCount: 7);

        controller.open();

        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.opening),
        );
      });

      test('onOpeningComplete() advances opening → revealed', () async {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Ensure count is seeded before opening.
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await _openAndComplete(controller);

        final finalState = container.read(secretBoxControllerProvider);
        expect(finalState.phase, equals(SecretBoxPhase.revealed));
        expect(finalState.reward, isNotNull);
      });

      test('revealed state contains reward with name and kind', () async {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        await Future<void>.delayed(const Duration(milliseconds: 10));
        await _openAndComplete(controller);

        final state = container.read(secretBoxControllerProvider);
        expect(state.reward!.name, isNotEmpty);
        expect(state.reward!.kind, isNotNull);
      });
    });

    group('error handling', () {
      test('onOpeningComplete() error → closed with errorMessage', () async {
        final container = _container(
          secretBox: FakeSecretBoxRepository.none(),
        );
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Force phase to opening so onOpeningComplete acts.
        // ignore: invalid_use_of_protected_member
        controller.state =
            controller.state.copyWith(phase: SecretBoxPhase.opening);

        await controller.onOpeningComplete();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed));
        expect(state.errorMessage, isNotNull);
        expect(state.reward, isNull);
      });

      test('Dart Error in repo resets phase → closed', () async {
        final container = _container(
          secretBox: FakeSecretBoxRepository.throwingError(),
        );
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // ignore: invalid_use_of_protected_member
        controller.state =
            controller.state.copyWith(phase: SecretBoxPhase.opening);

        await controller.onOpeningComplete();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed),
            reason: 'A Dart Error must reset phase to closed, not leave it '
                'stuck in opening');
        expect(state.errorMessage, isNotNull);
        expect(state.reward, isNull);
      });

      test('error clears on next successful open', () async {
        // Start with error.
        final container = ProviderContainer(
          overrides: [
            secretBoxRepositoryProvider
                .overrideWithValue(FakeSecretBoxRepository.none()),
          ],
        );
        addTearDown(container.dispose);

        final ctrl = container.read(secretBoxControllerProvider.notifier);
        // ignore: invalid_use_of_protected_member
        ctrl.state = ctrl.state.copyWith(phase: SecretBoxPhase.opening);
        await ctrl.onOpeningComplete();

        expect(
          container.read(secretBoxControllerProvider).errorMessage,
          isNotNull,
        );

        // Switch to data repo.
        container.updateOverrides([
          secretBoxRepositoryProvider
              .overrideWithValue(FakeSecretBoxRepository.empty()),
        ]);

        // Re-read notifier after override switch; clear the error and seed phase.
        final ctrl2 = container.read(secretBoxControllerProvider.notifier);
        // ignore: invalid_use_of_protected_member
        ctrl2.state = SecretBoxUiState(
          phase: SecretBoxPhase.opening,
          unopenedCount: 7,
        );
        await ctrl2.onOpeningComplete();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.revealed));
        expect(state.errorMessage, isNull);
        expect(state.reward, isNotNull);
      });
    });

    group('double-tap guard', () {
      test('open() is ignored while opening phase is active', () {
        final container = _container(
          secretBox: FakeSecretBoxRepository.loading(),
        );
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Seed count manually so the guard for count<=0 does not fire.
        // ignore: invalid_use_of_protected_member
        controller.state =
            controller.state.copyWith(unopenedCount: 7);

        controller.open(); // → opening

        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.opening),
        );

        controller.open(); // second tap — should be ignored

        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.opening),
        );
      });
    });

    group('close()', () {
      test('transitions any phase to closed, clears reward and error', () async {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        await Future<void>.delayed(const Duration(milliseconds: 10));
        await _openAndComplete(controller);

        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.revealed),
        );

        controller.close();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed));
        expect(state.reward, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('reset() alias', () {
      test('reset() behaves identically to close()', () async {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        await Future<void>.delayed(const Duration(milliseconds: 10));
        await _openAndComplete(controller);

        controller.reset();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed));
        expect(state.reward, isNull);
      });
    });
  });
}
