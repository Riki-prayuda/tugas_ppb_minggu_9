import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToOrderScrreen extends StatefulWidget {
  const AddToOrderScrreen({super.key});

  @override
  State<AddToOrderScrreen> createState() => _AddToOrderScrreenState();
}

class _AddToOrderScrreenState extends State<AddToOrderScrreen> {
  bool isLoading = true;

  List cartData = [];

  final String cartUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/cart";

  @override
  void initState() {
    super.initState();
    getCart();
  }

  // =====================================
  // GET CART API
  // =====================================
  Future<void> getCart() async {
    try {
      final response = await http.get(Uri.parse(cartUrl));

      final data = jsonDecode(response.body);

      setState(() {
        cartData = data["data"];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text("Cart"), backgroundColor: Colors.orange),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartData.isEmpty
          ? const Center(child: Text("Cart Kosong"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartData.length,
              itemBuilder: (context, index) {
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
                          cartData[index]["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text("Harga : Rp ${cartData[index]["price"]}"),

                        const SizedBox(height: 6),

                        Text("Jumlah : ${cartData[index]["count"]}"),

                        const SizedBox(height: 6),

                        Text(
                          "Total : Rp ${cartData[index]["total_price"]}",
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
    );
  }
}
