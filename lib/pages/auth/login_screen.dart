import 'package:flutter/material.dart';
import 'package:school/home.dart';
import 'package:school/pages/defauult/home_screen.dart';
import 'package:school/utils/string_Helpers.dart';
import 'package:school/helpers/jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isVisiable = true;
  bool _autoFocus = true;
  bool _isLoading = false;

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('Token saved successfully: $token');
    } catch (e) {
      print('Error saving token: $e');
      // Nếu không lưu được token, vẫn cho phép đăng nhập
      print('Continuing without saving token...');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Future.delayed(Duration(seconds: 2));

        if (_emailController.text == 'admin@gmail.com' &&
            _passwordController.text == '123456') {
          // Generate fake JWT token
          String token = generateFakeJWT();
          print('Generated token: $token');

          // Try to save token but don't block if it fails
          await _saveToken(token);

          if (!mounted) return;

          // Show success message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đăng nhập thành công!')));

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  ExpenseTrackerScreen()),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sai tài khoản hoặc mật khẩu!')),
          );
        }
      } catch (e) {
        print('Login error: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trang đăng nhập',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Đăng nhập ",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: _emailController,
                      autofocus: _autoFocus,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Nhập email của bạn",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: StringHelpers.validateEmail,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _isVisiable,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Nhập mật khẩu của bạn",
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isVisiable
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isVisiable = !_isVisiable;
                            });
                          },
                        ),
                      ),
                      validator: StringHelpers.validatePassword,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child:
                          _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                "Đăng nhập",
                                style: TextStyle(color: Colors.white),
                              ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
