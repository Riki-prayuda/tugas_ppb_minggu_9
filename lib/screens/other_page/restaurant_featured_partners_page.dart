import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main_menu/add_to_order_page.dart';

class FeaturedScreen extends StatelessWidget {
  const FeaturedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RestaurantPage();
  }
}

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isLoading = true;
  List menuData = [];

  final String menuUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/menu";

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  // ============================
  // GET DATA API
  // ============================
  Future<void> getMenu() async {
    try {
      final response = await http.get(Uri.parse(menuUrl));
      final data = jsonDecode(response.body);

      setState(() {
        menuData = data["data"];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================
  // ADD TO CART
  // ============================
  Future<void> addToCart(String name, int price) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList("cart") ?? [];

    bool found = false;

    for (int i = 0; i < cart.length; i++) {
      Map item = jsonDecode(cart[i]);

      if (item["name"] == name) {
        item["qty"] = item["qty"] + 1;
        cart[i] = jsonEncode(item);
        found = true;
      }
    }

    if (!found) {
      cart.add(jsonEncode({"name": name, "price": price, "qty": 1}));
    }

    await prefs.setStringList("cart", cart);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$name added to cart")));
  }

  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Restaurant"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddToOrderScrreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuData.length,
              itemBuilder: (context, index) {
                final item = menuData[index];
                String imageUrl = item["image"] ?? "";

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        child: Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          // loading
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              height: 180,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                            );
                          },
                        ),
                      ),

                      // ============================
                      // CONTENT
                      // ============================
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text("Rp ${item["price"]}"),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  addToCart(item["name"], item["price"]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: const Text("Add To Cart"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
