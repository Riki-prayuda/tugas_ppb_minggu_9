import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // kembali
          },
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: demoData.length,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemBuilder: (context, index) => OnboardContent(
                title: demoData[index]["title"],
                text: demoData[index]["text"],
                image: demoData[index]["image"],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              demoData.length,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                width: currentPage == index ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.green
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),

              onPressed: () {
                if (currentPage == demoData.length - 1) {
                  Navigator.pop(context); // selesai onboarding
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },

              child: Text(
                currentPage == demoData.length - 1 ? "GET STARTED" : "NEXT",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String title, text, image;

  const OnboardContent({
    super.key,
    required this.title,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> demoData = [
  {
    "image": "assets/img/BG.jpg",
    "title": "All your favorites",
    "text": "Best food delivered fast",
  },
  {
    "image": "assets/img/BG.jpg",
    "title": "Free delivery offers",
    "text": "Special promo for you",
  },
  {
    "image": "assets/img/BG.jpg",
    "title": "Choose your food",
    "text": "Many menus available",
  },
];
