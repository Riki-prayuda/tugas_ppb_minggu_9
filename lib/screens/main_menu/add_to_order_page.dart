import 'dart:convert';
import 'package:flutter/material.dart';
import '../other_page/checkout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToOrderScrreen extends StatefulWidget {
  const AddToOrderScrreen({super.key});

  @override
  State<AddToOrderScrreen> createState() => _AddToOrderScrreenState();
}

class _AddToOrderScrreenState extends State<AddToOrderScrreen> {
  List<Map<String, dynamic>> cartData = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  // =====================================
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cart = prefs.getStringList("cart") ?? [];

    setState(() {
      cartData = cart.map((e) {
        return jsonDecode(e) as Map<String, dynamic>;
      }).toList();
    });
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cart = cartData.map((item) {
      return jsonEncode(item);
    }).toList();

    await prefs.setStringList("cart", cart);
  }

  // =====================================
  void plus(int index) {
    setState(() {
      cartData[index]["qty"]++;
    });

    saveCart();
  }

  void minus(int index) {
    setState(() {
      if (cartData[index]["qty"] > 1) {
        cartData[index]["qty"]--;
      } else {
        cartData.removeAt(index);
      }
    });

    saveCart();
  }

  void deleteItem(int index) {
    setState(() {
      cartData.removeAt(index);
    });

    saveCart();
  }

  int totalPrice() {
    int total = 0;

    for (var item in cartData) {
      total += (item["price"] as int) * (item["qty"] as int);
    }

    return total;
  }

  // =====================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.orange,
      ),

      body: cartData.isEmpty
          ? const Center(
              child: Text("Cart Empty", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartData.length,
              itemBuilder: (context, index) {
                final item = cartData[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
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

                        const SizedBox(height: 8),

                        Text("Rp ${item["price"]}"),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    minus(index);
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),

                                Text(
                                  item["qty"].toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),

                                IconButton(
                                  onPressed: () {
                                    plus(index);
                                  },
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            IconButton(
                              onPressed: () {
                                deleteItem(index);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),

                        Text(
                          "Subtotal : Rp ${item["price"] * item["qty"]}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: cartData.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total : Rp ${totalPrice()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cartData.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutPage(),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  loadCart(); // refresh cart/keranjang belanja
                                }
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
