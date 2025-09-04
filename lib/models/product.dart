class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final List<int>? reviews;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.reviews,
  });

  double? get averageRating {
    if (reviews == null || reviews!.isEmpty) return null;
    return reviews!.reduce((a, b) => a + b) / reviews!.length;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      reviews: json['reviews'] != null ? List<int>.from(json['reviews']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        if (reviews != null) 'reviews': reviews,
      };
}
