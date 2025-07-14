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

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int active;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      active: json['active'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'active': active,
    };
  }
} 