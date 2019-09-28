class Division {
  String _id;
  String idDivision;
  String idManager;
  String name;

  Division();

  String get id => _id;

  Division.fromJson(Map<String, dynamic> json) {
    this._id = json['_id'];
    this.idDivision = json['id_division'];
    this.idManager = json['id_manager'];
    this.name = json['name'];
  }
}
