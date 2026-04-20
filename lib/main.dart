import 'package:flutter/material.dart';

// ================= IMPORT SCREENS =================
import 'screens/onboarding_screen.dart';
import 'screens/home_page.dart';
import 'screens/profile_detail_page.dart';
import 'screens/add_to_order_page.dart';
import 'screens/order_details_page.dart';
import 'screens/filters_page.dart';
import 'screens/search_details_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/reset_email_page.dart';
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart';
import 'screens/restaurant_details_page.dart';
import 'screens/restaurant_featured_partners_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// ======================================================
// MAIN APP
// ======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: const MainScreen(),
    );
  }
}

// ======================================================
// MAIN SCREEN
// ======================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  // ================= PAGE LIST =================
  final List<Widget> pages = [
    const FoodAppHomeScreen(),
    const FeaturedScreen(),
    const ProfileScreen(),
  ];

  final List<String> titles = ["Home", "Restaurants", "Profile"];

  // ================= CHANGE PAGE =================
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });

    Navigator.pop(context);
  }

  // ================= OPEN PAGE =================
  void openPage(Widget page) {
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      // ==================================================
      // DRAWER
      // ==================================================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              accountName: Text("Food Delivery App"),
              accountEmail: Text("Flutter Project"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.fastfood, color: Colors.orange, size: 35),
              ),
            ),

            // ================= MAIN MENU =================
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "Main Menu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => changePage(0),
            ),

            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text("Restaurants"),
              onTap: () => changePage(1),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => changePage(2),
            ),

            const Divider(),

            // ================= OTHER PAGES =================
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Text(
                "Other Pages",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.slideshow),
              title: const Text("Onboarding"),
              onTap: () => openPage(const OnboardingScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Sign In"),
              onTap: () => openPage(const SignInScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text("Sign Up"),
              onTap: () => openPage(const SignUpScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.filter_alt),
              title: const Text("Filters"),
              onTap: () => openPage(const FilterScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Search"),
              onTap: () => openPage(const SearchScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text("Restaurant Details"),
              onTap: () => openPage(const RestaurantDetailsScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text("Add To Order"),
              onTap: () => openPage(const AddToOrderScrreen()),
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("Order Details"),
              onTap: () => openPage(const OrderDetailsScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Forgot Password"),
              onTap: () => openPage(const ForgotPasswordScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text("Reset Password"),
              onTap: () => openPage(const ResetEmailSentScreen()),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Close Drawer"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SafeArea(
        child: IndexedStack(index: currentIndex, children: pages),
      ),

      // ==================================================
      // BOTTOM NAVIGATION
      // ==================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Restaurant",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
