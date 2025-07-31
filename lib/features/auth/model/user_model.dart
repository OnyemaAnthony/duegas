class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? dob;
  String? gender;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.dob,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'dob': dob,
      'gender': gender,
    };
  }
}
