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

  void paymentMethodDialog() {
    List<String> bankList = ["BCA", "BRI", "BNI", "Mandiri"];

    List<String> walletList = ["Dana", "OVO", "GoPay", "ShopeePay"];

    String selectedName = paymentMethod == "Not Set" ? "BCA" : paymentMethod;

    String selectedType = walletList.contains(paymentMethod)
        ? "E-Wallet"
        : "Bank";

    TextEditingController numberController = TextEditingController(
      text: paymentNumber,
    );

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          IconData getIcon(String name) {
            switch (name) {
              case "BCA":
              case "BRI":
              case "BNI":
              case "Mandiri":
                return Icons.account_balance;

              case "Dana":
              case "OVO":
              case "GoPay":
              case "ShopeePay":
                return Icons.account_balance_wallet;

              default:
                return Icons.credit_card;
            }
          }

          Color getColor(String name) {
            switch (name) {
              case "BCA":
                return Colors.blue;
              case "BRI":
                return Colors.indigo;
              case "BNI":
                return Colors.orange;
              case "Mandiri":
                return Colors.amber;
              case "Dana":
                return Colors.blue;
              case "OVO":
                return Colors.purple;
              case "GoPay":
                return Colors.cyan;
              case "ShopeePay":
                return Colors.deepOrange;
              default:
                return Colors.grey;
            }
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            title: const Center(child: Text("Payment Methods")),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: getColor(selectedName).withOpacity(0.15),
                    child: Icon(
                      getIcon(selectedName),
                      size: 32,
                      color: getColor(selectedName),
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField(
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(value: "Bank", child: Text("Bank")),
                      DropdownMenuItem(
                        value: "E-Wallet",
                        child: Text("E-Wallet"),
                      ),
                    ],
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedType = value!;

                        selectedName = selectedType == "Bank" ? "BCA" : "Dana";

                        numberController.clear();
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  DropdownButtonFormField(
                    value: selectedName,
                    items: (selectedType == "Bank" ? bankList : walletList)
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedName = value!;
                        numberController.clear();
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: numberController,
                    decoration: InputDecoration(
                      labelText: selectedType == "Bank"
                          ? "Account Number"
                          : "Phone Number",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColor(selectedName),
                ),
                onPressed: () {
                  setState(() {
                    paymentMethod = selectedName;
                    paymentNumber = numberController.text;
                  });

                  saveData();

                  Navigator.pop(context);

                  showSnack("Payment Saved");
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  void editLocation() {
    TextEditingController loc = TextEditingController(text: userAddress);

    bool isLoading = false;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          Future<void> detectLocation() async {
            setStateDialog(() {
              isLoading = true;
            });

            try {
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );

              List<Placemark> placemarks = await placemarkFromCoordinates(
                position.latitude,
                position.longitude,
              );

              Placemark place = placemarks.first;

              // 🔥 FULL ADDRESS + REGION
              String fullAddress = [
                place.street,
                place.subLocality,
                place.locality,
                place.administrativeArea,
                place.country,
              ].where((e) => e != null && e.isNotEmpty).join(", ");

              loc.text = fullAddress;
            } catch (e) {
              showSnack("Failed detect location");
            }

            setStateDialog(() {
              isLoading = false;
            });
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            title: const Text("Location Settings"),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: loc,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                    ),
                    labelText: "Your Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : detectLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      isLoading ? "Detecting..." : "Use Current Location",
                    ),
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() {
                    userAddress = loc.text;
                  });

                  saveData(); // 🔥 SIMPAN

                  Navigator.pop(context);

                  showSnack("Location Saved");
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  void notificationSetting() {
    bool tempValue = notificationEnabled;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Notifications"),
            content: SwitchListTile(
              value: tempValue,
              onChanged: (value) {
                setStateDialog(() {
                  tempValue = value;
                });
              },
              title: Text(tempValue ? "Notification ON" : "Notification OFF"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    notificationEnabled = tempValue;
                  });

                  saveData();

                  Navigator.pop(context);

                  showSnack(
                    notificationEnabled
                        ? "Notifications Enabled"
                        : "Notifications Disabled",
                  );
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }

  void referFriend() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Refer Friends"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.card_giftcard, size: 60, color: Colors.orange),
            SizedBox(height: 12),
            Text(
              "Invite your friends and get Rp 20.000 voucher!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showSnack("Referral link copied");
            },
            child: const Text("Share"),
          ),
        ],
      ),
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure want logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

    void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}