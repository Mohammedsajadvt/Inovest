import 'package:flutter/material.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/custom_button.dart';
import 'package:inovest/core/utils/custom_text_field.dart';
import 'package:inovest/data/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      final response = await _authService.forgotPassword(_emailController.text.trim());
      
      setState(() => _isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?.message ?? 'An error occurred'),
          backgroundColor: response?.success == true ? Colors.green : Colors.red,
        ),
      );

      if (response?.success == true) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[1],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppArray().colors[5],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter your email address and we\'ll send you instructions to reset your password.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppArray().colors[3],
                ),
              ),
              SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
                    title: 'Send Reset Instructions',
                    backgroundColor: AppArray().colors[0],
                    textColor: AppArray().colors[1],
                    onTap: _handleSubmit,
                  ),
            ],
          ),
        ),
      ),
    );
  }
} 