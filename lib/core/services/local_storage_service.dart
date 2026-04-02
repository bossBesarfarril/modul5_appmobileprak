import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  
  // Keys untuk pemisahan data
  static const String _savedDosenKey = 'saved_users';
  static const String _savedMahasiswaKey = 'saved_mahasiswa';

  // --- Token Management ---
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // --- Data User Aktif ---
  Future<void> saveUser({required String userId, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // ==========================================
  // --- DOSEN: Local Storage Operations ---
  // ==========================================
  Future<void> addDosenToSavedList({required String userId, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedDosenKey) ?? [];

    final isDuplicate = rawList.any((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['user_id'] == userId;
    });

    if (isDuplicate) return;

    final newUser = jsonEncode({
      'user_id': userId,
      'username': username,
      'saved_at': DateTime.now().toIso8601String(),
    });

    rawList.add(newUser);
    await prefs.setStringList(_savedDosenKey, rawList);
  }

  Future<List<Map<String, String>>> getSavedDosen() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedDosenKey) ?? [];

    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return {
        'user_id': (map['user_id'] ?? '').toString(),
        'username': (map['username'] ?? '').toString(),
        'saved_at': (map['saved_at'] ?? '').toString(),
      };
    }).toList();
  }

  Future<void> removeSavedDosen(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedDosenKey) ?? [];

    rawList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['user_id'] == userId;
    });

    await prefs.setStringList(_savedDosenKey, rawList);
  }

  Future<void> clearSavedDosen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedDosenKey);
  }

  // ==========================================
  // --- MAHASISWA: Local Storage Operations ---
  // ==========================================
  Future<void> addMahasiswaToSavedList({required String userId, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedMahasiswaKey) ?? [];

    final isDuplicate = rawList.any((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['user_id'] == userId;
    });

    if (isDuplicate) return;

    final newUser = jsonEncode({
      'user_id': userId,
      'username': username,
      'saved_at': DateTime.now().toIso8601String(),
    });

    rawList.add(newUser);
    await prefs.setStringList(_savedMahasiswaKey, rawList);
  }

  Future<List<Map<String, String>>> getSavedMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedMahasiswaKey) ?? [];

    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return {
        'user_id': (map['user_id'] ?? '').toString(),
        'username': (map['username'] ?? '').toString(),
        'saved_at': (map['saved_at'] ?? '').toString(),
      };
    }).toList();
  }

  Future<void> removeSavedMahasiswa(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_savedMahasiswaKey) ?? [];

    rawList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['user_id'] == userId;
    });

    await prefs.setStringList(_savedMahasiswaKey, rawList);
  }

  Future<void> clearSavedMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedMahasiswaKey);
  }

  // --- Clear All ---
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}