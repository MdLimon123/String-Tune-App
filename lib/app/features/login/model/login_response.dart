import 'dart:convert';

/// API shape (flat):
/// `{ "success": true, "message": "...", "access": "jwt", "user": { ... } }`
///
/// Also supports legacy `{ "data": { "access", "refresh" } }`.
class LoginResponse {
  const LoginResponse({
    this.success,
    this.message,
    this.access,
    this.user,
    this.data,
  });

  final bool? success;
  final String? message;
  final String? access;
  final LoginUser? user;
  final Data? data;

  /// Use this to persist the session token.
  String? get effectiveToken => (access != null && access!.isNotEmpty)
      ? access
      : (data?.access != null && data!.access!.isNotEmpty)
          ? data!.access
          : null;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      access: json['access'] as String?,
      user: json['user'] is Map
          ? LoginUser.fromJson(
              Map<String, dynamic>.from(json['user'] as Map<dynamic, dynamic>))
          : null,
      data: json['data'] is Map
          ? Data.fromJson(
              Map<String, dynamic>.from(json['data'] as Map<dynamic, dynamic>))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'access': access,
        'user': user?.toJson(),
        'data': data?.toJson(),
      };
}

class LoginUser {
  const LoginUser({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.image,
  });

  final int? id;
  final String? fullName;
  final String? username;
  final String? email;
  final String? image;

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: (json['id'] as num?)?.toInt(),
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'username': username,
        'email': email,
        'image': image,
      };
}

class Data {
  const Data({this.refresh, this.access});

  final String? refresh;
  final String? access;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        refresh: json['refresh'] as String?,
        access: json['access'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'refresh': refresh,
        'access': access,
      };
}

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
