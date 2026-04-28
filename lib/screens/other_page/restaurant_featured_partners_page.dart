import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeaturedScreen extends StatelessWidget {
  const FeaturedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Menu API"),
        backgroundColor: Colors.orange,
      ),
      body: const Body(),
    );
  }
}

// =========================================
// BODY
// =========================================
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = true;
  List menuData = [];

  final String menuUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/menu";

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  // =========================================
  // GET DATA API
  // =========================================
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

  // =========================================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.only(
                          topLeft:
                              Radius.circular(14),
                          topRight:
                              Radius.circular(14),
                        ),
                        child: Image.network(
                          menuData[index]["image"],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              menuData[index]["name"],
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              "Harga : Rp ${menuData[index]["price"]}",
                              style:
                                  const TextStyle(
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(
                                height: 6),

                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                const SizedBox(
                                    width: 4),
                                Text(
                                  menuData[index]["star"]
                                      .toString(),
                                ),
                              ],
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