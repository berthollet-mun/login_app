import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}

class Cart extends Equatable {
  final List<CartItem> items;
  final String? userId;

  const Cart({
    this.items = const [],
    this.userId,
  });

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => items.isEmpty;

  Cart copyWith({
    List<CartItem>? items,
    String? userId,
  }) {
    return Cart(
      items: items ?? this.items,
      userId: userId ?? this.userId,
    );
  }

  Cart addItem(Product product, {int quantity = 1}) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingIndex] = CartItem(
        product: product,
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      return copyWith(items: updatedItems);
    } else {
      return copyWith(items: [...items, CartItem(product: product, quantity: quantity)]);
    }
  }

  Cart removeItem(String productId) {
    return copyWith(
      items: items.where((item) => item.product.id != productId).toList(),
    );
  }

  Cart updateItemQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      return removeItem(productId);
    }

    final updatedItems = items.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: quantity);
      }
      return item;
    }).toList();

    return copyWith(items: updatedItems);
  }

  Cart clear() {
    return const Cart();
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'userId': userId,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as String?,
    );
  }

  @override
  List<Object?> get props => [items, userId];
}
