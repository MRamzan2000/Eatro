import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static late final SharedPreferences _prefs;

  /// Initialize once in main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Keys (centralized)
  static const String _keyIsLoggedIn = "isLoggedIn";
  static const String _keyUid = "uid";
  static const String _keyEmail = "email";
  static const String _keyName = "name";
  static const String _keyPhotoUrl = "photoUrl";
  static const String _keyPassword = "password"; // new

  /// Save login status
  static Future<void> setLogin(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  static bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

  /// Save user data (password optional to stay backwards compatible)
  static Future<void> saveUser({
    required String uid,
    required String email,
    String? name,
    String? photoUrl,
    String? password, // optional
  }) async {
    await _prefs.setString(_keyUid, uid);
    await _prefs.setString(_keyEmail, email);
    if (name != null) await _prefs.setString(_keyName, name);
    if (photoUrl != null) await _prefs.setString(_keyPhotoUrl, photoUrl);
    if (password != null) await _prefs.setString(_keyPassword, password);
    await setLogin(true); // auto mark as logged in
  }

  /// Set/update password separately if needed
  static Future<void> setPassword(String password) async {
    await _prefs.setString(_keyPassword, password);
  }

  /// Getters (safe, null handled)
  static String? get uid => _prefs.getString(_keyUid);
  static String? get email => _prefs.getString(_keyEmail);
  static String? get name => _prefs.getString(_keyName);
  static String? get photoUrl => _prefs.getString(_keyPhotoUrl);
  static String? get password => _prefs.getString(_keyPassword); // new getter

  /// Clear all data (Logout)
  static Future<void> logout() async {
    await _prefs.clear();
  }
}
