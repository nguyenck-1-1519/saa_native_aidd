import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/auth/data/datasources/google_sign_in_data_source.dart';
import 'package:saa_2025/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:saa_2025/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';

class MockGoogleSignInDataSource extends Mock
    implements GoogleSignInDataSource {}

class MockSupabaseAuthDataSource extends Mock
    implements SupabaseAuthDataSource {}

void main() {
  late MockGoogleSignInDataSource mockGoogle;
  late MockSupabaseAuthDataSource mockSupabase;
  late AuthRepositoryImpl repo;

  setUp(() {
    mockGoogle = MockGoogleSignInDataSource();
    mockSupabase = MockSupabaseAuthDataSource();
    repo = AuthRepositoryImpl(
      googleSignIn: mockGoogle,
      supabaseAuth: mockSupabase,
    );
  });

  group('AuthRepositoryImpl.signInWithGoogle', () {
    test('success: returns authenticated user (FUN_009)', () async {
      final tokens = const GoogleTokens(idToken: 'id-token-123');
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
      );

      when(() => mockGoogle.signIn()).thenAnswer((_) async => tokens);
      when(() => mockSupabase.signInWithIdToken(
            idToken: 'id-token-123',
            accessToken: null,
          )).thenAnswer((_) async => user);

      final result = await repo.signInWithGoogle();

      expect(result, equals(user));
      verify(() => mockGoogle.signIn()).called(1);
      verify(() => mockSupabase.signInWithIdToken(
            idToken: 'id-token-123',
            accessToken: null,
          )).called(1);
    });

    test('Google cancel: rethrows AuthCancelled (FUN_010)', () async {
      when(() => mockGoogle.signIn())
          .thenThrow(const AuthCancelled('User cancelled'));

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<AuthCancelled>()),
      );
    });

    test('SocketException: maps to NetworkFailure', () async {
      when(() => mockGoogle.signIn())
          .thenThrow(SocketException('Network error'));

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('AuthApiException 400: maps to AccountDisabled (ACC_003)',
        () async {
      final tokens = const GoogleTokens(idToken: 'id-token-123');
      when(() => mockGoogle.signIn()).thenAnswer((_) async => tokens);
      when(() => mockSupabase.signInWithIdToken(
            idToken: 'id-token-123',
            accessToken: null,
          )).thenThrow(
        AuthApiException(
          'Bad request',
          statusCode: '400',
        ),
      );

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<AccountDisabled>()),
      );
    });

    test('AuthApiException 403: maps to AccountDisabled', () async {
      final tokens = const GoogleTokens(idToken: 'id-token-123');
      when(() => mockGoogle.signIn()).thenAnswer((_) async => tokens);
      when(() => mockSupabase.signInWithIdToken(
            idToken: 'id-token-123',
            accessToken: null,
          )).thenThrow(
        AuthApiException(
          'Forbidden',
          statusCode: '403',
        ),
      );

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<AccountDisabled>()),
      );
    });

    test('AuthApiException 500: maps to UnknownFailure (FUN_015)', () async {
      final tokens = const GoogleTokens(idToken: 'id-token-123');
      when(() => mockGoogle.signIn()).thenAnswer((_) async => tokens);
      when(() => mockSupabase.signInWithIdToken(
            idToken: 'id-token-123',
            accessToken: null,
          )).thenThrow(
        AuthApiException(
          'Server error',
          statusCode: '500',
        ),
      );

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('AuthException: maps to UnknownFailure', () async {
      final tokens = const GoogleTokens(idToken: 'id-token-123');
      when(() => mockGoogle.signIn()).thenAnswer((_) async => tokens);
      when(() => mockSupabase.signInWithIdToken(
            idToken: 'id-token-123',
            accessToken: null,
          )).thenThrow(
        const AuthException('Auth error'),
      );

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('unknown exception: maps to UnknownFailure', () async {
      when(() => mockGoogle.signIn()).thenThrow(Exception('Unknown'));

      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('AuthRepositoryImpl.signOut', () {
    test('calls both datasources', () async {
      when(() => mockGoogle.signOut()).thenAnswer((_) async {});
      when(() => mockSupabase.signOut()).thenAnswer((_) async {});

      await repo.signOut();

      verify(() => mockGoogle.signOut()).called(1);
      verify(() => mockSupabase.signOut()).called(1);
    });
  });

  group('AuthRepositoryImpl.watchAuthState', () {
    test('delegates to supabase datasource', () async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
      );
      when(() => mockSupabase.watchAuthState())
          .thenAnswer((_) => Stream.fromIterable([null, user]));

      final stream = repo.watchAuthState();

      expect(stream, emitsInOrder([null, user]));
    });
  });

  group('AuthRepositoryImpl.currentUser', () {
    test('returns supabase currentUser', () {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
      );
      when(() => mockSupabase.currentUser).thenReturn(user);

      final result = repo.currentUser;

      expect(result, equals(user));
    });
  });
}
