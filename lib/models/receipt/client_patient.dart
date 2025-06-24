class Client {
  final String name;
  final String firstname;
  final String phone;
  final String address;

  Client({
    required this.name,
    required this.firstname,
    required this.phone,
    required this.address,
  });

  factory Client.fromMap(Map<String, dynamic> m) => Client(
    name:      m['name'] as String,
    firstname: m['firstname'] as String,
    phone:     m['phone'] as String,
    address:   m['address'] as String,
  );

  Map<String, dynamic> toMap() => {
    'name':      name,
    'firstname': firstname,
    'phone':     phone,
    'address':   address,
  };
}
