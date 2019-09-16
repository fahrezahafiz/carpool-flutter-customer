class Driver {
  String id;
  String name;
  String phone;
  String licensePlate;
  String vehicleName;

  Driver.fromTrip(Map<String, dynamic> driver) {
    this.id = driver['id'];
    this.name = driver['name'];
    this.phone = driver['phone'];
    this.licensePlate = driver['license_plate'];
    this.vehicleName = driver['vehicle']['name'];
  }
}
