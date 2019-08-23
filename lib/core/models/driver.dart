class Driver {
  String id;
  String name;
  String email;
  String password;
  String phone;
  String imageProfile;
  String imageKtp;
  String imageSim;
  DateTime birthday;
  int totalDistance;
  int totalTime;
  bool verified;
  int amountWork;
  int positionLat;
  int positionLng;
  DateTime updatedAt;
  DateTime createdAt;

  Driver({
    this.id,
    this.email,
    this.imageKtp,
    this.imageSim,
    this.amountWork,
    this.totalDistance,
    this.totalTime,
    this.verified,
    this.positionLat,
    this.positionLng,
    this.updatedAt,
    this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => new Driver(
        id: json["_id"],
        email: json["email"],
        imageKtp: json["image_ktp"],
        imageSim: json["image_sim"],
        amountWork: json["amount_work"],
        totalDistance: json["total_distance"],
        totalTime: json["total_time"],
        verified: json["verified"],
        positionLat: json["position_lat"],
        positionLng: json["position_lng"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "image_ktp": imageKtp,
        "image_sim": imageSim,
        "amount_work": amountWork,
        "total_distance": totalDistance,
        "total_time": totalTime,
        "verified": verified,
        "position_lat": positionLat,
        "position_lng": positionLng,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
