import 'package:demo_project/app/core/theme/app_colors.dart';
import 'package:demo_project/app/core/utils/custom_appbar.dart';
import 'package:flutter/material.dart';

class ShowSetupPage extends StatefulWidget {
  const ShowSetupPage({super.key});

  @override
  State<ShowSetupPage> createState() => _ShowSetupPageState();
}

class _ShowSetupPageState extends State<ShowSetupPage> {

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Ernie Ball Regular Slinky Electric Guitar Strings',
      'gauge': '.010 – .046',
      'price': '\$20',
      'rating': '4.8',
      'image': 'assets/image/dummy.png',
    },
    {
      'name': 'Ernie Ball Regular Slinky Electric Guitar Strings',
      'gauge': '.010 – .046',
      'price': '\$20',
      'rating': '4.8',
      'image': 'assets/image/dummy.png',
    },
    {
      'name': 'Ernie Ball Regular Slinky Electric Guitar Strings',
      'gauge': '.010 – .046',
      'price': '\$20',
      'rating': '4.8',
      'image': 'assets/image/dummy.png',
    },
    {
      'name': 'Ernie Ball Regular Slinky Electric Guitar Strings',
      'gauge': '.010 – .046',
      'price': '\$20',
      'rating': '4.8',
      'image': 'assets/image/dummy.png',
    },
    {
      'name': 'Ernie Ball Regular Slinky Electric Guitar Strings',
      'gauge': '.010 – .046',
      'price': '\$20',
      'rating': '4.8',
      'image': 'assets/image/dummy.png',
    },
    {
      'name': 'Ernie Ball Regular Slinky Electric Guitar Strings',
      'gauge': '.010 – .046',
      'price': '\$20',
      'rating': '4.8',
      'image': 'assets/image/dummy.png',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(title: "Show This Setup"),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.58,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // card background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,

                height: 140,
                color: Color(0xFF0F172A),
                child: Image.asset(product['image'], fit: BoxFit.contain),
              ),
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  product['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Gauge
                Text(
                  product['gauge'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),

                // Price + Rating row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFF9333EA),
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          product['rating'],
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}
