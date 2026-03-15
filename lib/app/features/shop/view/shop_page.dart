import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<String> filters = [
    'All',
    'Doom',
    'Sludge',
    'Drone',
    'Stoner',
    'Metal',
    'Blues',
    'Jazz',
  ];

  String selected = 'All';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Image.asset('assets/image/app_logo.png', height: 20, width: 137),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24,),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hint: Text(
                        'Search by artist,',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      fillColor: Color(0xFF0F172A),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF94A3B8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF9D4EDD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        borderSide: BorderSide(color: Color(0xFF94A3B8)),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icon/search.svg'),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF94A3B8)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset('assets/icon/scan.svg'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((label) {
                  final isSelected = selected == label;
                  return GestureDetector(
                    onTap: () => setState(() => selected = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF9333EA)
                            : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF9333EA)
                              : const Color(0xFF475569),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                      
           
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.56,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              ),
            ),
          ],
        ),
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
