import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List cartData = [];

  String selectedPayment = "";
  String userAddress = "";
  String paymentMethod = "";
  String paymentNumber = "";

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  // =============================
  Future<void> loadAllData() async {
    final prefs = await SharedPreferences.getInstance();

    // ambil order lama
    List<String> oldOrder = prefs.getStringList("order") ?? [];

    // ambil cart/pesanan baru
    List<String> cart = prefs.getStringList("cart") ?? [];

    // gabungkan pesanan lama dan baru
    oldOrder.addAll(cart);

    // simpan kembali
    await prefs.setStringList("order", oldOrder);

    // hapus cart
    await prefs.remove("cart");

    setState(() {
      cartData = cart.map((e) => jsonDecode(e)).toList();

      userAddress = prefs.getString("userAddress") ?? "-";

      paymentMethod = prefs.getString("paymentMethod") ?? "-";

      paymentNumber = prefs.getString("paymentNumber") ?? "-";

      selectedPayment = "$paymentMethod - $paymentNumber";
    });
  }

  // =============================
  int totalPrice() {
    int total = 0;

    for (var item in cartData) {
      total += (item["price"] as int) * (item["qty"] as int);
    }

    return total;
  }

  // =============================
  String formatRupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}";
  }

  // =============================
  Future<void> checkout() async {
    final prefs = await SharedPreferences.getInstance();

    // DEBUG
    print("Payment: $selectedPayment");

    // CLEAR CART
    await prefs.remove("cart");

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Order placed successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.orange,
      ),

      body: cartData.isEmpty
          ? const Center(
              child: Text("Cart is empty", style: TextStyle(fontSize: 18)),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===================
                  // CART LIST
                  // ===================
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartData.length,
                      itemBuilder: (context, index) {
                        final item = cartData[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(item["name"]),
                            subtitle: Text(
                              "${item["qty"]} x ${formatRupiah(item["price"])}",
                            ),
                            trailing: Text(
                              formatRupiah(
                                (item["price"] as int) * (item["qty"] as int),
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ===================
                  // ADDRESS
                  // ===================
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Colors.orange),
                      title: const Text("Payment"),
                      subtitle: Text(selectedPayment),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        showPaymentDialog();
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===================
                  // PAYMENT
                  // ===================
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Colors.orange),
                      title: const Text("Payment"),
                      subtitle: Text("$paymentMethod - $paymentNumber"),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===================
                  // TOTAL
                  // ===================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total", style: TextStyle(fontSize: 18)),
                        Text(
                          formatRupiah(totalPrice()),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===================
                  // BUTTON
                  // ===================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Confirm Order"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void showPaymentDialog() {
    List<String> methods = ["Dana", "OVO", "BCA", "Mandiri"];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choose Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: methods.map((method) {
            return ListTile(
              title: Text(method),
              onTap: () {
                setState(() {
                  selectedPayment = method;
                });

                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
