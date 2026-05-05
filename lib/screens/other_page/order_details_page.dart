import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final String apiUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/cart";

  List<Map<String, dynamic>> orderItems = [];

  bool isLoading = true;
  int subtotal = 0;

  @override
  void initState() {
    super.initState();
    loadOrder();
    fetchCartFromAPI();
  }

  // ==========================
  // LOAD ORDER (LOCAL STORAGE)
  // ==========================
  Future<void> loadOrder() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> order = prefs.getStringList("order") ?? [];

    orderItems = order
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();

    subtotal = 0;

    for (var item in orderItems) {
      subtotal +=
          int.parse(item["price"].toString()) *
          int.parse(item["qty"].toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  // ==========================
  // FETCH API
  // ==========================
  Future<void> fetchCartFromAPI() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      final data = jsonDecode(response.body);

      print("API DATA: $data"); // debug
    } catch (e) {
      print("API error");
    }
  }

  // ==========================
  String rupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }

  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderItems.isEmpty
          ? const Center(
              child: Text("Belum ada pesanan", style: TextStyle(fontSize: 18)),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// LIST ORDER
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];

                        int total =
                            int.parse(item["price"].toString()) *
                            int.parse(item["qty"].toString());

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              /// QTY
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item["qty"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              /// INFO
                              Expanded(
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
                                    Text(
                                      rupiah(
                                        int.parse(item["price"].toString()),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// TOTAL
                              Text(
                                rupiah(total),
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// SUMMARY
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        rowPrice("Subtotal", rupiah(subtotal)),
                        const SizedBox(height: 10),
                        rowPrice("Delivery", "Free"),
                        const Divider(height: 25),
                        rowPrice("Total", rupiah(subtotal), bold: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget rowPrice(String title, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: bold ? Colors.deepOrange : Colors.black,
          ),
        ),
      ],
    );
  }
}
