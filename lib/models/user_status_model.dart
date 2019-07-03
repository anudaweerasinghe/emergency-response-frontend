class UserStatus{

  int id;
  String phone;
  int accessCode;
  String imguri;
  String division;
  String name;
  double lat;
  double lng;

  UserStatus({
    this.id,
    this.phone,
    this.accessCode,
    this.imguri,
    this.division,
    this.name,
    this.lat,
    this.lng

  });

  factory UserStatus.fromJson(Map<String, dynamic> json){
    return new UserStatus(
        id: json['id'],
        phone: json['phone'],
        accessCode: json['accessCode'],
        imguri: json['imguri'],
        division: json['division'],
        name: json['name'],
        lat:json['lat'],
        lng:json['lng']
    );
  }

}