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
  }) : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId: iosClientId?.isNotEmpty == true ? iosClientId : null,
              serverClientId:
                  serverClientId?.isNotEmpty == true ? serverClientId : null,
              scopes: const ['email', 'profile'],
            );

  final GoogleSignIn _googleSignIn;

  /// Runs the interactive sign-in. Throws [AuthCancelled] if the user backs out.
  Future<GoogleTokens> signIn() async {
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
