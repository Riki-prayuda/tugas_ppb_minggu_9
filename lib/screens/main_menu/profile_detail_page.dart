import 'package:flutter/material.dart';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ===============================
  // DATA USER
  // ===============================
  String? profileImagePath;
  String userName = "Widi User";
  String userEmail = "user@email.com";
  String userAddress = "Palangkaraya, Indonesia";

  bool notificationEnabled = true;

  String paymentMethod = "Not Set";
  String paymentNumber = "";

  // ===============================
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("userName") ?? "Widi User";

      userEmail = prefs.getString("userEmail") ?? "user@email.com";

      userAddress = prefs.getString("userAddress") ?? "Palangkaraya, Indonesia";

      notificationEnabled = prefs.getBool("notif") ?? true;

      paymentMethod = prefs.getString("paymentMethod") ?? "Not Set";

      paymentNumber = prefs.getString("paymentNumber") ?? "";

      profileImagePath = prefs.getString("profileImage");
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("userName", userName);

    await prefs.setString("userEmail", userEmail);

    await prefs.setString("userAddress", userAddress);

    await prefs.setBool("notif", notificationEnabled);

    await prefs.setString("paymentMethod", paymentMethod);

    await prefs.setString("paymentNumber", paymentNumber);

    await prefs.setString("profileImage", profileImagePath ?? "");
  }

  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.orange,
                          backgroundImage:
                              profileImagePath != null &&
                                  profileImagePath!.isNotEmpty
                              ? FileImage(File(profileImagePath!))
                              : null,
                          child:
                              profileImagePath == null ||
                                  profileImagePath!.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 45,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userEmail,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                buildMenu(
                  icon: Icons.person,
                  title: "Profile Information",
                  sub: "Edit your account data",
                  press: editProfile,
                ),

                buildMenu(
                  icon: Icons.lock,
                  title: "Change Password",
                  sub: "Update your password",
                  press: changePassword,
                ),

                buildMenu(
                  icon: Icons.credit_card,
                  title: "Payment Methods",
                  sub: paymentMethod == "Not Set"
                      ? "Choose payment method"
                      : "$paymentMethod - $paymentNumber",
                  press: paymentMethodDialog,
                ),

                buildMenu(
                  icon: Icons.location_on,
                  title: "Locations",
                  sub: userAddress,
                  press: editLocation,
                ),

                buildMenu(
                  icon: Icons.notifications,
                  title: "Notifications",
                  sub: notificationEnabled ? "ON" : "OFF",
                  press: notificationSetting,
                ),

                buildMenu(
                  icon: Icons.share,
                  title: "Refer Friends",
                  sub: "Invite friends",
                  press: referFriend,
                ),

                buildMenu(
                  icon: Icons.logout,
                  color: Colors.red,
                  title: "Logout",
                  sub: "Sign out account",
                  press: logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================
  Widget buildMenu({
    required IconData icon,
    required String title,
    required String sub,
    required VoidCallback press,
    Color color = Colors.black,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: ListTile(
        onTap: press,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // ==========================
  // FUNCTIONS
  // ==========================

  void editProfile() {
    TextEditingController name = TextEditingController(text: userName);

    TextEditingController email = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                userName = name.text;
                userEmail = email.text;
              });

              saveData();

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });

      saveData();
    }
  }

  void changePassword() {
    TextEditingController oldPass = TextEditingController();

    TextEditingController newPass = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Old Password"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showSnack("Password updated successfully");
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }