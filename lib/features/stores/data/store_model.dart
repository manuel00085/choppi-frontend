class StoreModel {
  final int id;
  final String name;
   final String? address;

  StoreModel({
    required this.id,
    required this.name,
    this.address,
    
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      address: json['address'], // opcional
    );
  }
}
