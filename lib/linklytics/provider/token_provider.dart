import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_portfolio_flutter/linklytics/provider/jwt_token_notifier.dart';

final tokenProvider = Provider<bool?>((ref) {
  final token = ref.watch(jwtTokenProvider);
  if (token == null) return null; // No token means no authentication
  return JwtDecoder.isExpired(token);
});
