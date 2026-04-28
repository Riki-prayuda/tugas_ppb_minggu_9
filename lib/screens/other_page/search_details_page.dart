import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final String apiUrl =
      "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/menu";

  List menuList = [];
  List filteredList = [];

  bool isLoading = true;

  final TextEditingController
      searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  /// ======================
  /// FETCH API
  /// ======================
  Future<void> fetchMenu() async {
    try {
      final response =
          await http.get(Uri.parse(apiUrl));

      final data =
          jsonDecode(response.body);

      setState(() {
        menuList = data["data"];
        filteredList = menuList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ======================
  /// SEARCH FILTER
  /// ======================
  void searchMenu(String value) {
    setState(() {
      filteredList = menuList
          .where((item) => item["name"]
              .toString()
              .toLowerCase()
              .contains(
                  value.toLowerCase()))
          .toList();
    });
  }

  String rupiah(int price) {
    return "Rp $price";
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
          "Search Menu",
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(
                  16),
          child: Column(
            children: [

              /// SEARCH BAR
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                          16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .black
                          .withOpacity(
                              0.05),
                      blurRadius: 8,
                    )
                  ],
                ),
                child:
                    TextField(
                  controller:
                      searchController,
                  onChanged:
                      searchMenu,
                  decoration:
                      const InputDecoration(
                    border:
                        InputBorder.none,
                    icon: Icon(
                      Icons.search,
                    ),
                    hintText:
                        "Search food...",
                  ),
                ),
              ),

              const SizedBox(
                  height: 20),

              Expanded(
                child: isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(),
                      )
                    : filteredList
                            .isEmpty
                        ? const Center(
                            child: Text(
                                "Menu not found"),
                          )
                        : ListView.builder(
                            itemCount:
                                filteredList
                                    .length,
                            itemBuilder:
                                (context,
                                    index) {
                              final item =
                                  filteredList[
                                      index];

                              return Container(
                                margin:
                                    const EdgeInsets.only(
                                        bottom:
                                            16),
                                padding:
                                    const EdgeInsets.all(
                                        12),
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
                                child:
                                    Row(
                                  children: [

                                    /// IMAGE
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(
                                              15),
                                      child:
                                          Image.network(
                                        item["image"],
                                        width:
                                            90,
                                        height:
                                            90,
                                        fit: BoxFit
                                            .cover,
                                      ),
                                    ),

                                    const SizedBox(
                                        width:
                                            15),

                                    /// DETAIL
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
                                                  8),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color:
                                                    Colors.orange,
                                                size:
                                                    18,
                                              ),
                                              Text(
                                                  " ${item["star"]}"),
                                            ],
                                          ),

                                          const SizedBox(
                                              height:
                                                  8),

                                          Text(
                                            rupiah(
                                                item["price"]),
                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.deepOrange,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    CircleAvatar(
                                      backgroundColor:
                                          Colors.black,
                                      child:
                                          IconButton(
                                        onPressed:
                                            () {},
                                        icon:
                                            const Icon(
                                          Icons.add,
                                          color: Colors
                                              .white,
                                        ),
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
        ),
      ),
    );
  }
}