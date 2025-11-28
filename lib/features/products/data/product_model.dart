class ProductModel {
  final int id;
  final String name;
  final String? description;
  final String? category;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.images = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      category: json["category"],
      images: json["images"] != null
          ? List<String>.from(json["images"])
          : [],
    );
  }
}
