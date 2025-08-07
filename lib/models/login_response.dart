import 'user.dart';

class LoginResponse {
  final String message;
  final String status;
  final String token;
  final User user;

  LoginResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'user': user.toJson(),
    };
  }
} 