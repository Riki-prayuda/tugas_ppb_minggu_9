import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  final PageController pageController = PageController();

  bool isLoading = true;
  List menuData = [];

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

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPageOrStart() {
    if (currentPage < menuData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  // =====================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  const Spacer(),

                  Expanded(
                    flex: 14,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: menuData.length,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return OnboardContent(
                          image: menuData[index]["image"],
                          title: menuData[index]["name"],
                          text:
                              "Harga Rp ${menuData[index]["price"]}\nRating ${menuData[index]["star"]}",
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      menuData.length,
                      (index) => DotIndicator(isActive: index == currentPage),
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: nextPageOrStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22A45D),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        currentPage == menuData.length - 1
                            ? "GET STARTED"
                            : "NEXT",
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
    );
  }
}

// =====================================
// CONTENT
// =====================================
class OnboardContent extends StatelessWidget {
  final String image, title, text;

  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(child: Image.network(image, fit: BoxFit.contain)),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// =====================================
// DOT
// =====================================
class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 22 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF22A45D)
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
