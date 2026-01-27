import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // --- KEYS ---
  static const String _tokenKey = "auth_token";
  static const String _loginKey = "is_logged_in";
  static const String _userIdKey = "user_id";
  static const String _aboutSeenKey = "about_seen";
  static const String _accounttypekey = "account_type";
  static const String _namekey = "name";
  static const String _phonenumberkey = "phonenumber";
  static const String _fcmtokenkey = "fcmtoken";
  static const String _rememberMeKey = "remember_me";
  static const String _rememberEmailkey = "remember_email";
static const String _pointsKey = "points";
 static const String _serviceRequestIdKey = "service_request_id";
 static const String _userImageKey = "user_image";


  // --- Remember Flag --
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  static Future<bool> isRemeberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<void> saveRemeberEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rememberEmailkey, email);
  }

  static Future<String?> getRememberEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberEmailkey);
  }

  // clear remember data
  static Future<void> clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberEmailkey);
    await prefs.setBool(_rememberMeKey, false);
  }

//--- Service Request ---

  // -- save profile data ---

  // Save
static Future<void> saveProfileData(Map<String, dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('profileData', jsonEncode(data));
}

// Get
static Future<Map<String, dynamic>?> getProfileData() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString('profileData');
  if (data == null) return null;
  return jsonDecode(data);
}


  // ================== TOKEN ==================
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
static Future<void> savefcmToken(String fcmtoken)async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_fcmtokenkey, fcmtoken);
}
static Future<String> getfcmToken()async{
 final prefs = await SharedPreferences.getInstance();
 return await prefs.getString(_fcmtokenkey) ?? '';
}
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ================== LOGIN FLAG ==================   
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  // ================== ABOUT SCREEN ==================
  static Future<void> setAboutSeen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_aboutSeenKey, value);
  }

  static Future<bool> hasSeenAbout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_aboutSeenKey) ?? false;
  }
static Future<void> savePoints(int value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_pointsKey, value);
}

static Future<int> getPoints() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_pointsKey) ?? 0;
}


  // ================== USER ID ==================
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // === UserImage ====
  static Future<void> saveUserImage(String image) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userImageKey, image);
}
static Future<String?> getUserImage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userImageKey);
}
  // --- Phone Number ----

  static Future<void> savephonenumber(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phonenumberkey, value);
  }

  static Future<String?> getphonenumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phonenumberkey);
  }
  // ---- ACCOUNT TYPE ----

  // save account type
  static Future<void> saveAccountType(String accountType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accounttypekey, accountType);
  }

  // get accounttype
  static Future<String?> getaccounttype() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accounttypekey);
  }

  // ---- User Name --
  static Future<void> saveusername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_namekey, name);
  }

  static Future<String?> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_namekey);
  }



static Future<void> clearAll() async {
  final prefs = await SharedPreferences.getInstance();

  // Save remember-me values temporarily
  final bool rememberMe = prefs.getBool(_rememberMeKey) ?? false;
  final String? rememberEmail = prefs.getString(_rememberEmailkey);

  // Clear everything
  await prefs.clear();

  // Restore remember-me values
  await prefs.setBool(_rememberMeKey, rememberMe);
  if (rememberEmail != null) {
    await prefs.setString(_rememberEmailkey, rememberEmail);
  }
}

}
