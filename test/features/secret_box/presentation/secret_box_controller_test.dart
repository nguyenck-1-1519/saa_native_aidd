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

      test('transitions closed → opening → revealed on open()', () async {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Before open.
        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.closed),
        );

        // Start open (should transition to opening immediately).
        final openFuture = controller.open();

        // FakeSecretBoxRepository resolves immediately, so the state
        // will be revealed before we can check the "opening" phase.
        // What matters is that open() completes and the state is revealed.
        await openFuture;

        final finalState = container.read(secretBoxControllerProvider);
        expect(finalState.phase, equals(SecretBoxPhase.revealed));
        expect(finalState.reward, isNotNull);
        expect(finalState.reward!.id, equals('fake-reward-1'));
      });

      test('includes reward name and descriptor in revealed state', () async {
        final container = _container();
        addTearDown(container.dispose);

        await container
            .read(secretBoxControllerProvider.notifier)
            .open();

        final state = container.read(secretBoxControllerProvider);
        expect(state.reward!.name, equals('Test Reward'));
        expect(state.reward!.descriptor, equals('Test descriptor'));
      });
    });

    group('error handling', () {
      test('returns to closed with errorMessage on open() failure', () async {
        final container = _container(
          secretBox: FakeSecretBoxRepository.none(),
        );
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        await controller.open();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed));
        expect(state.errorMessage, isNotNull);
        expect(state.reward, isNull);
      });

      test('returns to closed with errorMessage when repo throws a Dart Error',
          () async {
        // H1 regression: a non-Exception throwable (StateError / LateInitializationError)
        // must NOT leave phase stuck in `opening`, which would lock the double-tap guard.
        final container = _container(
          secretBox: FakeSecretBoxRepository.throwingError(),
        );
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        await controller.open();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed),
            reason: 'A Dart Error must reset phase to closed, not leave it '
                'stuck in opening');
        expect(state.errorMessage, isNotNull);
        expect(state.reward, isNull);
      });

      test('clears errorMessage on next successful open()', () async {
        // Start with error.
        var container = ProviderContainer(
          overrides: [
            secretBoxRepositoryProvider
                .overrideWithValue(FakeSecretBoxRepository.none()),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(secretBoxControllerProvider.notifier)
            .open();

        expect(
          container.read(secretBoxControllerProvider).errorMessage,
          isNotNull,
        );

        // Switch to data repo.
        container.updateOverrides([
          secretBoxRepositoryProvider
              .overrideWithValue(FakeSecretBoxRepository.empty()),
        ]);

        await container
            .read(secretBoxControllerProvider.notifier)
            .open();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.revealed));
        expect(state.errorMessage, isNull);
        expect(state.reward, isNotNull);
      });
    });

    group('double-tap guard', () {
      test('ignores second open() call while opening is in flight', () async {
        final container = _container(
          secretBox: FakeSecretBoxRepository.loading(),
        );
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Start first open — never completes.
        controller.open();
        await Future<void>.delayed(const Duration(milliseconds: 1));

        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.opening),
        );

        // Try second open — should be ignored (phase stays opening).
        controller.open();

        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.opening),
        );
      });
    });

    group('reset()', () {
      test('transitions any phase to closed, clears reward and error', () async {
        final container = _container();
        addTearDown(container.dispose);

        final controller =
            container.read(secretBoxControllerProvider.notifier);

        // Reach revealed state.
        await controller.open();
        expect(
          container.read(secretBoxControllerProvider).phase,
          equals(SecretBoxPhase.revealed),
        );

        // Reset.
        controller.reset();

        final state = container.read(secretBoxControllerProvider);
        expect(state.phase, equals(SecretBoxPhase.closed));
        expect(state.reward, isNull);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
