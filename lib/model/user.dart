class User {
  String username;
  String email;
  final String createAt;
  final String id;
  User({
    required this.username,
    required this.email,
    required this.id,
    required this.createAt,
  });

  set setUsername(String name) => username = name;
  set setEmail(String newEmail) => email = newEmail;

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        id = json['id'],
        createAt = json['createAt'];
  Map<String, dynamic> toMap() =>
      {'id': id, 'username': username, 'email': email, 'createAt': createAt};
}
