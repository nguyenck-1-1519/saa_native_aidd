import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/failures.dart';

/// Tokens returned by the native Google sign-in flow.
class GoogleTokens {
  const GoogleTokens({required this.idToken, this.accessToken});
  final String idToken;
  final String? accessToken;
}

/// Wraps the native `google_sign_in` plugin.
///
/// On iOS the client id is read from `Info.plist` (`GIDClientID`); the web
/// client id is passed as `serverClientId` so the returned idToken's audience
/// is accepted by Supabase.
class GoogleSignInDataSource {
  GoogleSignInDataSource({
    String? iosClientId,
    String? serverClientId,
    GoogleSignIn? googleSignIn,
  })  : _hasClientId = (iosClientId?.isNotEmpty ?? false) ||
            (serverClientId?.isNotEmpty ?? false),
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId: iosClientId?.isNotEmpty == true ? iosClientId : null,
              serverClientId:
                  serverClientId?.isNotEmpty == true ? serverClientId : null,
              scopes: const ['email', 'profile'],
            );

  final GoogleSignIn _googleSignIn;
  final bool _hasClientId;

  /// Runs the interactive sign-in. Throws [AuthCancelled] if the user backs out.
  Future<GoogleTokens> signIn() async {
    // Guard: calling native GoogleSignIn without a configured client id raises
    // an uncatchable native exception on iOS. Fail with a domain error instead.
    if (!_hasClientId) {
      throw const UnknownFailure('Google Sign-In is not configured');
    }
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw const AuthCancelled('User cancelled Google sign-in');
    }
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw const UnknownFailure('Google returned no idToken');
    }
    return GoogleTokens(idToken: idToken, accessToken: auth.accessToken);
  }

  Future<void> signOut() => _googleSignIn.signOut();
}
