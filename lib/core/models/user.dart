class User {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String imageProfile;
  String role;
  String idManager;
  DateTime birth;
  int totalTime;
  int totalDistance;
  String idDivision;
  bool active;
  bool verified;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.imageProfile,
      this.role,
      this.idManager,
      this.birth,
      this.totalTime = 0,
      this.totalDistance = 0,
      this.idDivision,
      this.active = false,
      this.verified = false});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        imageProfile: json["image_profile"],
        role: json["role"],
        idManager: json["id_manager"],
        birth: DateTime.parse(json["birth"]),
        totalTime: json["total_time"],
        totalDistance: json["total_distance"],
        idDivision: json["id_division"],
        active: json["active"],
        verified: json['verified'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "image_profile": imageProfile,
        "role": role,
        "id_manager": idManager,
        "birth": birth.toString(),
        "total_time": totalTime,
        "total_distance": totalDistance,
        "id_division": idDivision,
        "active": active,
        "verified": verified,
      };
}
