import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../domain/entities/auth_user.dart';

/// Maps a Supabase [User] to the domain [AuthUser].
abstract final class AuthUserModel {
  static AuthUser fromSupabase(User user) {
    final meta = user.userMetadata ?? const <String, dynamic>{};
    return AuthUser(
      id: user.id,
      email: user.email ?? (meta['email'] as String? ?? ''),
      displayName:
          (meta['full_name'] ?? meta['name']) as String?,
      photoUrl: (meta['avatar_url'] ?? meta['picture']) as String?,
    );
  }
}
