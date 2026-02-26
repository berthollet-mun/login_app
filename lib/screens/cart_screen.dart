import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => context.go('/'),
        ),
      ),
      body: const _CartContent(),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent();

  @override
  Widget build(BuildContext context) {
    // Sample cart items
    final cartItems = [
      _CartItemData(
        id: '1',
        name: 'Wireless Headphones',
        price: 129.99,
        quantity: 1,
        imageUrl: 'https://via.placeholder.com/80',
      ),
      _CartItemData(
        id: '2',
        name: 'Smart Watch',
        price: 199.99,
        quantity: 1,
        imageUrl: 'https://via.placeholder.com/80',
      ),
    ];

    final subtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final shipping = subtotal > 50 ? 0.0 : 9.99;
    final total = subtotal + shipping;

    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.cartShopping,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some products to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Start Shopping',
              width: 200,
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Cart Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartItem(context, item);
            },
          ),
        ),
        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'Shipping',
                  shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
                ),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Total',
                  '\$${total.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Proceed to Checkout',
                  onPressed: () {
                    // TODO: Implement checkout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checkout coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, _CartItemData item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          FontAwesomeIcons.trash,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // TODO: Remove item from cart
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.image,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity Controls
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: FontAwesomeIcons.minus,
                        onPressed: () {
                          // TODO: Decrease quantity
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: FontAwesomeIcons.plus,
                        onPressed: () {
                          // TODO: Increase quantity
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Total Price
            Text(
              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.black : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

class _CartItemData {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  _CartItemData({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}
