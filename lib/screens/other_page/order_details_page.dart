import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends State<OrderDetailsScreen> {
  final String apiUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/cart";

  List cartItems = [];
  bool isLoading = true;

  int subtotal = 0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  /// ==========================
  /// FETCH CART API
  /// ==========================
  Future<void> fetchCart() async {
    try {
      final response =
          await http.get(Uri.parse(apiUrl));

      final data =
          jsonDecode(response.body);

      cartItems = data["data"];

      subtotal = 0;
      for (var item in cartItems) {
        subtotal +=
            item["total_price"]
                as int;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String rupiah(int value) {
    return "Rp $value";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF8F9FD),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Your Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.all(
                      16),
              child: Column(
                children: [

                  /// LIST ITEM
                  Expanded(
                    child:
                        ListView.builder(
                      itemCount:
                          cartItems.length,
                      itemBuilder:
                          (context,
                              index) {
                        final item =
                            cartItems[
                                index];

                        return Container(
                          margin:
                              const EdgeInsets.only(
                                  bottom:
                                      16),
                          padding:
                              const EdgeInsets.all(
                                  14),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white,
                            borderRadius:
                                BorderRadius.circular(
                                    18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withOpacity(
                                        0.05),
                                blurRadius:
                                    8,
                              )
                            ],
                          ),
                          child:
                              Row(
                            children: [

                              /// COUNT
                              Container(
                                width:
                                    40,
                                height:
                                    40,
                                alignment:
                                    Alignment.center,
                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .orange
                                      .withOpacity(
                                          0.1),
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                                child:
                                    Text(
                                  item["count"]
                                      .toString(),
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        Colors.orange,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width:
                                      14),

                              /// INFO
                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["name"],
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
                                            6),
                                    Text(
                                      rupiah(item[
                                          "price"]),
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                rupiah(item[
                                    "total_price"]),
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .deepOrange,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// SUMMARY
                  Container(
                    padding:
                        const EdgeInsets.all(
                            18),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .white,
                      borderRadius:
                          BorderRadius.circular(
                              20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withOpacity(
                                  0.05),
                          blurRadius:
                              8,
                        )
                      ],
                    ),
                    child: Column(
                      children: [

                        rowPrice(
                          "Subtotal",
                          rupiah(
                              subtotal),
                        ),

                        const SizedBox(
                            height: 10),

                        rowPrice(
                          "Delivery",
                          "Free",
                        ),

                        const Divider(
                            height:
                                25),

                        rowPrice(
                          "Total",
                          rupiah(
                              subtotal),
                          bold: true,
                        ),

                        const SizedBox(
                            height:
                                18),

                        SizedBox(
                          width: double
                              .infinity,
                          child:
                              ElevatedButton(
                            onPressed:
                                () {},
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    16,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        15),
                              ),
                            ),
                            child:
                                Text(
                              "Checkout (${rupiah(subtotal)})",
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget rowPrice(
    String title,
    String value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.normal,
            color: bold
                ? Colors.deepOrange
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}