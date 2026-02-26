import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ShopEasy',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Find your favorite products',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.cartShopping),
            onPressed: () => context.go('/cart'),
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.user),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: const _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    // Sample products data
    final products = [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 129.99,
        originalPrice: 199.99,
        imageUrl: 'https://via.placeholder.com/150',
        categories: ['Electronics', 'Audio'],
        rating: 4.5,
        reviewCount: 128,
        brand: 'AudioTech',
        isInStock: true,
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        description: 'Fitness tracking smartwatch with heart rate monitor',
        price: 199.99,
        originalPrice: 249.99,
        imageUrl: 'https://via.placeholder.com/150',
        categories: ['Electronics', 'Wearables'],
        rating: 4.3,
        reviewCount: 256,
        brand: 'TechWear',
        isInStock: true,
      ),
      Product(
        id: '3',
        name: 'Running Shoes',
        description: 'Comfortable running shoes for daily workouts',
        price: 89.99,
        imageUrl: 'https://via.placeholder.com/150',
        categories: ['Sports', 'Footwear'],
        rating: 4.7,
        reviewCount: 89,
        brand: 'RunFast',
        isInStock: true,
      ),
      Product(
        id: '4',
        name: 'Laptop Backpack',
        description:
            'Water-resistant laptop backpack with multiple compartments',
        price: 49.99,
        originalPrice: 79.99,
        imageUrl: 'https://via.placeholder.com/150',
        categories: ['Accessories', 'Bags'],
        rating: 4.2,
        reviewCount: 45,
        brand: 'CarryAll',
        isInStock: true,
      ),
      Product(
        id: '5',
        name: 'Coffee Maker',
        description: 'Programmable coffee maker with thermal carafe',
        price: 79.99,
        imageUrl: 'https://via.placeholder.com/150',
        categories: ['Home', 'Kitchen'],
        rating: 4.6,
        reviewCount: 312,
        brand: 'BrewMaster',
        isInStock: true,
      ),
      Product(
        id: '6',
        name: 'Bluetooth Speaker',
        description: 'Portable Bluetooth speaker with 360-degree sound',
        price: 59.99,
        originalPrice: 89.99,
        imageUrl: 'https://via.placeholder.com/150',
        categories: ['Electronics', 'Audio'],
        rating: 4.4,
        reviewCount: 167,
        brand: 'SoundWave',
        isInStock: true,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          Text(
            'Categories',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryCard(
                  context,
                  'Electronics',
                  FontAwesomeIcons.laptop,
                ),
                _buildCategoryCard(context, 'Fashion', FontAwesomeIcons.shirt),
                _buildCategoryCard(context, 'Home', FontAwesomeIcons.house),
                _buildCategoryCard(
                  context,
                  'Sports',
                  FontAwesomeIcons.basketball,
                ),
                _buildCategoryCard(context, 'Books', FontAwesomeIcons.book),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Featured Products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all products
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String name, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
