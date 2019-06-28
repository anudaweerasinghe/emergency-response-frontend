class User{

  int id;
  String phone;
  int accessCode;
  String imguri;
  String division;
  String name;

  User({
    this.id,
    this.phone,
    this.accessCode,
    this.imguri,
    this.division,
    this.name

  });

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
        id: json['id'],
        phone: json['phone'],
        accessCode: json['accessCode'],
        imguri: json['imguri'],
        division: json['division'],
        name: json['name']
    );
  }

}