import 'dart:convert';
import 'package:flutter/material.dart';

class OrderDetailItemPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailItemPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    List items = order["items"];

    int total = 0;

    for (var e in items) {
      final item = jsonDecode(e);
      total += int.parse(item["price"].toString()) *
          int.parse(item["qty"].toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Text("Status: ${order["status"]}"),
            Text("Tanggal: ${order["time"]}"),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: items.map((e) {
                  final item = jsonDecode(e);

                  int itemTotal =
                      int.parse(item["price"].toString()) *
                      int.parse(item["qty"].toString());

                  return ListTile(
                    title: Text(item["name"]),
                    subtitle: Text("x${item["qty"]}"),
                    trailing: Text("Rp $itemTotal"),
                  );
                }).toList(),
              ),
            ),

            Text(
              "Total: Rp $total",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}