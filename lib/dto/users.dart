class UserDTO {
  final int? id;
  final String? email;
  final String? token;
  final String? createdAt;
  final String? updatedAt;

  UserDTO({
    required this.id,
    required this.email,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'],
      email: json['email'],
      token: json['token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
