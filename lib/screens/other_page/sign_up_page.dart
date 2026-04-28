import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              WelcomeText(),
              SizedBox(height: 20),
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================
// WELCOME TEXT
// =====================================
class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Enter username and password for sign up",
        ),
      ],
    );
  }
}

// =====================================
// SIGN UP FORM
// =====================================
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() =>
      _SignUpFormState();
}

class _SignUpFormState
    extends State<SignUpForm> {
  final _formKey =
      GlobalKey<FormState>();

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool obscure = true;
  bool isLoading = false;

  // =====================================
  // SIGN UP (PAKAI ENDPOINT LOGIN)
  // =====================================
  Future<void> signUp() async {
    if (passwordController.text !=
        confirmController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Password tidak sama",
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url =
        "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok1/food-delivery/login";

    try {
      final response =
          await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/json",
        },
        body: jsonEncode({
          "username":
              usernameController.text,
          "password":
              passwordController.text,
        }),
      );

      final data =
          jsonDecode(response.body);

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            data["message"],
          ),
        ),
      );

      print(data["token"]);
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller:
                usernameController,
            decoration:
                const InputDecoration(
              hintText:
                  "Username",
            ),
          ),

          const SizedBox(
              height: 16),

          TextFormField(
            controller:
                passwordController,
            obscureText:
                obscure,
            decoration:
                InputDecoration(
              hintText:
                  "Password",
              suffixIcon:
                  IconButton(
                onPressed: () {
                  setState(() {
                    obscure =
                        !obscure;
                  });
                },
                icon: Icon(
                  obscure
                      ? Icons
                          .visibility_off
                      : Icons
                          .visibility,
                ),
              ),
            ),
          ),

          const SizedBox(
              height: 16),

          TextFormField(
            controller:
                confirmController,
            obscureText:
                obscure,
            decoration:
                const InputDecoration(
              hintText:
                  "Confirm Password",
            ),
          ),

          const SizedBox(
              height: 20),

          SizedBox(
            width:
                double.infinity,
            child:
                ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : signUp,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    const Color(
                        0xFF22A45D),
              ),
              child:
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors
                              .white,
                        )
                      : const Text(
                          "Sign Up",
                        ),
            ),
          ),

          const SizedBox(
              height: 20),

          Text.rich(
            TextSpan(
              text:
                  "Already have account? ",
              children: [
                TextSpan(
                  text:
                      "Sign In",
                  style:
                      const TextStyle(
                    color: Colors
                        .green,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}