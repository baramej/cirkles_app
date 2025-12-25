import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/secrets.dart';

class SupabaseAuth {
  static const secret = Secrets.kSupabaseUserPasswordSecret;

  static String generatePassword(String matrixUserId) {
    final input = utf8.encode('$matrixUserId$secret');
    final hash = sha256.convert(input);
    return hash.toString();
  }

  static Future<void> registerOrLogin(String username) async {
    final email = "$username@cirkles.app";
    final password = generatePassword(username);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthApiException catch (exception) {
      if (exception.code == "invalid_credentials") {
        // Register user
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );
      } else {
        rethrow;
      }
    }
  }
}
