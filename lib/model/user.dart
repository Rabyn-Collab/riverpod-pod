


class Shipping{
  final String address;
  final String city;
  final bool isEmpty;
  
   Shipping({
    required this.isEmpty,
    required this.address,
     required this.city
});
   
   factory Shipping.fromJson(Map<String, dynamic> json){
     return Shipping(
         isEmpty: json['isEmpty'],
         address: json['address'],
         city: json['city']
     );
   }


   
}


class User{
  final String fullname;
  final String email;
  final bool isAdmin;
  final Shipping shipping;
  final String token;
  final String id;


  User({
    required this.email,
    required this.fullname,
    required this.isAdmin,
    required this.shipping,
    required this.token,
    required this.id
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
     email: json['email'],
      id: json['id'],
      fullname: json['fullname'],
      token: json['token'],
      isAdmin: json['isAdmin'],
      shipping: Shipping.fromJson(json['shippingAddress'])
    );
  }
 
  
}