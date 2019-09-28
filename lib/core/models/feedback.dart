class Feedback {
  String idTrip;
  String idUser;
  String idDriver;
  double rating;
  String message;

  Feedback.fromJson(Map<String, dynamic> json) {
    this.idTrip = json['id_trip'];
    this.idUser = json['id_user'];
    this.idDriver = json['id_driver'];
    this.rating = double.parse(json['rating'].toString());
    this.message = json['message'];
  }

  Map<String, dynamic> toJson() => {
        "id_trip": idTrip,
        "id_user": idUser,
        "id_driver": idDriver,
        "rating": rating,
        "message": message
      };
}
