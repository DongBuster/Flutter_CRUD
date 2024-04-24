class User {
  String username;
  String email;
  final String id;
  User({
    required this.username,
    required this.email,
    required this.id,
  });

  set setUsername(String name) => username = name;
  set setEmail(String newEmail) => email = newEmail;
}
