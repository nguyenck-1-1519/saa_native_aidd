import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/config/env.dart';

void main() {
  group('Env config detection (login-crash regression)', () {
    test('placeholder values are NOT treated as configured', () {
      dotenv.testLoad(
        fileInput: '''
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_PUBLISHABLE_KEY=replace_with_local_anon_key_from_supabase_start
GOOGLE_CLIENT_ID=your_google_web_client_id
GOOGLE_IOS_CLIENT_ID=your_google_ios_client_id
''',
      );
      // Placeholder supabase key + placeholder google ids → not configured,
      // so the app falls back to FakeAuthRepository instead of crashing.
      expect(Env.hasSupabaseConfig, isFalse);
      expect(Env.hasGoogleConfig, isFalse);
    });

    test('real values are treated as configured', () {
      dotenv.testLoad(
        fileInput: '''
SUPABASE_URL=https://abcd.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_realkey123
GOOGLE_CLIENT_ID=1234-web.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=1234-ios.apps.googleusercontent.com
''',
      );
      expect(Env.hasSupabaseConfig, isTrue);
      expect(Env.hasGoogleConfig, isTrue);
    });

    test('empty values are not configured', () {
      dotenv.testLoad(fileInput: '');
      expect(Env.hasSupabaseConfig, isFalse);
      expect(Env.hasGoogleConfig, isFalse);
    });
  });
}
