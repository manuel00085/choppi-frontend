class StoreModel {
  final int id;
  final String name;

  StoreModel({
    required this.id,
    required this.name,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
