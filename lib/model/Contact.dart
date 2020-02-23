class Contact {
  int id;
  String name;
  String phone;
  String email;
  String image;

  Contact({this.name, this.phone, this.email, this.image});

  Contact.fromMap(Map map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
    email = map['email'];
    image = map['image'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
    };
    if (id != null) map['id'] = id;

    return map;
  }

  @override
  String toString() {
    return 'Contact[ id: $id, name: $name, phone: $phone, email: $email, image: $image]';
  }
}
