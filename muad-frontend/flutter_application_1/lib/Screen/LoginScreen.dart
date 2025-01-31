import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/ForgetPasswordScreen.dart';
import 'package:flutter_application_1/Screen/HomeScreen.dart';
import 'package:flutter_application_1/Screen/SignUpScreen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'UserProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // التحقق من البريد الإلكتروني
  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  // التحقق من رقم الهاتف
  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r"^05\d{8}$");
    return phoneRegex.hasMatch(phone);
  }

  // التحقق من كلمة المرور
  bool isValidPassword(String password) {
    final hasUpperCase = RegExp(r'(?=.*[A-Z])');
    final hasSpecialCharacter = RegExp(r'(?=.*[!@#$%^&(),.?":{}|<>])');
    final hasMinLength = password.length >= 8;
    return hasUpperCase.hasMatch(password) &&
        hasSpecialCharacter.hasMatch(password) &&
        hasMinLength;
  }

  // دالة تسجيل الدخول
  Future<void> _login() async {
    final emailOrPhone = _emailOrPhoneController.text.trim();
    final password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      final apiUrl = 'http://193.122.65.160/api/login';

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'email_or_phone': emailOrPhone,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);
            final user = data['user'];

            final firstName = user['first_name'] ?? 'Unknown';
            final lastName = user['last_name'] ?? 'Unknown';
            final phone = user['phone_number'] ?? 'Unknown';
            final email = user['email'] ?? 'Unknown';
            final password = user['password'] ?? 'Unknown';

            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            userProvider.setUserDetails(
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phone,
              email: email,
              password: password,
            );

            // الانتقال إلى الشاشة الرئيسية
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } catch (e) {
            _showErrorDialog('Error parsing response: $e');
          }
        } else {
          _showErrorDialog('Failed to login, please try again');
        }
      } catch (e) {
        _showErrorDialog('Error: $e');
      }
    }
  }

  // دالة لعرض رسالة الخطأ
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double buttonFontSize = 18.0;
    const double buttonHeight = 60.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B666E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Log In',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/Logo.png',
                  height: 180,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF2B666E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailOrPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Email or Phone:',
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF2B666E),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email or phone';
                    }
                    if (RegExp(r'^[0-9]').hasMatch(value)) {
                      if (!isValidPhone(value)) {
                        return 'Phone number must start with 05 and contain 10 digits';
                      }
                    } else {
                      if (!isValidEmail(value)) {
                        return 'Invalid email address format';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password:',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFF2B666E),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF2B666E),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password';
                    }
                    if (!isValidPassword(value)) {
                      return 'Password must be at least 8 characters long, contain one uppercase letter, and one special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B666E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(double.infinity, buttonHeight),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF2B666E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: Color(0xFF2B666E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
