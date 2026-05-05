import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_detail_item_page.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> storedOrders = prefs.getStringList("orders") ?? [];

    List<Map<String, dynamic>> tempOrders = [];

    for (var e in storedOrders) {
      Map<String, dynamic> order = jsonDecode(e) as Map<String, dynamic>;

      DateTime orderTime = DateTime.parse(order["time"]);

      // AUTO UPDATE STATUS
      if (DateTime.now().difference(orderTime).inSeconds > 10) {
        order["status"] = "Done";
      }

      tempOrders.add(order);
    }

    // SIMPAN STATUS UPDATE
    await prefs.setStringList(
      "orders",
      tempOrders.map((e) => jsonEncode(e)).toList(),
    );

    orders = tempOrders;

    setState(() {
      isLoading = false;
    });
  }

  Color getStatusColor(String status) {
    if (status == "Done") return Colors.green;
    return Colors.orange;
  }

  Icon getStatusIcon(String status) {
    if (status == "Done") {
      return const Icon(Icons.check_circle, color: Colors.green, size: 18);
    }
    return const Icon(Icons.access_time, color: Colors.orange, size: 18);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FD),

      appBar: AppBar(title: const Text("Order History"), centerTitle: true),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text("Belum ada pesanan"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                List items = order["items"];

                int total = 0;

                for (var e in items) {
                  final item = jsonDecode(e);
                  total +=
                      int.parse(item["price"].toString()) *
                      int.parse(item["qty"].toString());
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailItemPage(order: order),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order #${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /// STATUS DAN ICON
                            Row(
                              children: [
                                getStatusIcon(order["status"]),
                                const SizedBox(width: 6),
                                Text(
                                  order["status"],
                                  style: TextStyle(
                                    color: getStatusColor(order["status"]),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// DATE
                        Text(
                          order["time"],
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 10),

                        /// TOTAL
                        Text(
                          "Total: Rp $total",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
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
