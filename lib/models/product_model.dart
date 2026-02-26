import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final bool isInStock;
  final int quantity;
  final String? brand;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.categories,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isInStock = true,
    this.quantity = 0,
    this.brand,
    this.createdAt,
  });

  double get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0.0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    bool? isInStock,
    int? quantity,
    String? brand,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isInStock: isInStock ?? this.isInStock,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'categories': categories,
      'rating': rating,
      'reviewCount': reviewCount,
      'isInStock': isInStock,
      'quantity': quantity,
      'brand': brand,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String,
      categories: List<String>.from(json['categories'] as List),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isInStock: json['isInStock'] as bool? ?? true,
      quantity: json['quantity'] as int? ?? 0,
      brand: json['brand'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        originalPrice,
        imageUrl,
        categories,
        rating,
        reviewCount,
        isInStock,
        quantity,
        brand,
        createdAt,
      ];
}
