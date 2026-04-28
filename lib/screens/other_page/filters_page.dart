import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() =>
      _FilterScreenState();
}

class _FilterScreenState
    extends State<FilterScreen> {
  bool isLoading = true;

  List menuData = [];
  List filteredData = [];

  final String menuUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/menu";

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  // =====================================
  // GET MENU API
  // =====================================
  Future<void> getMenu() async {
    try {
      final response =
          await http.get(Uri.parse(menuUrl));

      final data =
          jsonDecode(response.body);

      setState(() {
        menuData = data["data"];
        filteredData = menuData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================
  // FILTER HARGA
  // =====================================
  void filterPrice(int level) {
    setState(() {
      if (level == 1) {
        filteredData = menuData
            .where((item) =>
                item["price"] <= 15000)
            .toList();
      } else if (level == 2) {
        filteredData = menuData
            .where((item) =>
                item["price"] > 15000 &&
                item["price"] <= 20000)
            .toList();
      } else {
        filteredData = menuData
            .where((item) =>
                item["price"] > 20000)
            .toList();
      }
    });
  }

  // =====================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FB),

      appBar: AppBar(
        title: const Text(
          "Filter Menu",
        ),
        backgroundColor:
            Colors.orange,
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(
                    height: 16),

                // =============================
                // FILTER BUTTON
                // =============================
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal,
                    children: [
                      const SizedBox(
                          width: 16),

                      buildButton(
                        "\$",
                        () =>
                            filterPrice(
                                1),
                      ),

                      buildButton(
                        "\$\$",
                        () =>
                            filterPrice(
                                2),
                      ),

                      buildButton(
                        "\$\$\$",
                        () =>
                            filterPrice(
                                3),
                      ),

                      buildButton(
                        "All",
                        () {
                          setState(
                              () {
                            filteredData =
                                menuData;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 16),

                // =============================
                // MENU LIST
                // =============================
                Expanded(
                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets
                            .all(16),
                    itemCount:
                        filteredData
                            .length,
                    itemBuilder:
                        (context,
                            index) {
                      return Card(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom:
                              16,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  16),
                        ),
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.only(
                                topLeft:
                                    Radius.circular(
                                        16),
                                topRight:
                                    Radius.circular(
                                        16),
                              ),
                              child:
                                  Image.network(
                                filteredData[index]["image"],
                                height:
                                    180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.all(
                                14,
                              ),
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredData[index]["name"],
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          8),

                                  Text(
                                    "Rp ${filteredData[index]["price"]}",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.orange,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          6),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                          width:
                                              4),
                                      Text(
                                        filteredData[index]["star"]
                                            .toString(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }

  // =====================================
  Widget buildButton(
      String title,
      VoidCallback press) {
    return Padding(
      padding:
          const EdgeInsets.only(
              right: 12),
      child: ElevatedButton(
        onPressed: press,
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              Colors.white,
          foregroundColor:
              Colors.orange,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                    30),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}