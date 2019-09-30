class Company {
  String idCompany;
  String name;
  int level;

  Company.fromJson(Map<String, dynamic> json) {
    this.idCompany = json['id_company'];
    this.name = json['name'];
    this.level =
        json['level'] is int ? json['level'] : int.tryParse(json['level']);
  }

  Map<String, dynamic> toJson() => {
        'id_company': idCompany,
        'name': name,
        'level': level,
      };
}
