import 'package:e_health_system/features/auth/Presentation/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Global key for form validation.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: AppColors.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleSection(),
                const SizedBox(height: 24),
                _buildEmailField(),
                const SizedBox(height: 24),
                _buildPasswordField(),
                const SizedBox(height: 12),
                _buildForgotPasswordSection(),
                const SizedBox(height: 20),
                _buildSignInButton(),
                const SizedBox(height: 12),
                _buildSignUpSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the title section.
  Widget _buildTitleSection() {
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 36,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// Builds the email input field.
  Widget _buildEmailField() {
    return const CustomTextFormField(
      hint: 'Email',
      iconData: Icons.email,
    );
  }

  /// Builds the password input field.
  Widget _buildPasswordField() {
    return const CustomTextFormField(
      hint: 'Password',
      iconData: Icons.lock,
      isPassword: true,
    );
  }

  /// Builds the "Forgot your password?" section.
  Widget _buildForgotPasswordSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password functionality.
        },
        child: const Text(
          'Forgot your password?',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary,
          ),
        ),
      ),
    );
  }

  /// Builds the "Sign In" button.
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // TODO: Handle sign in logic.
          context.go('/home');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

  /// Builds the sign-up navigation section.
  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 17),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              ),
            );
          },
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 17,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom TextFormField widget to handle email and password inputs.
class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hint,
    required this.iconData,
    this.suffixIcon,
    this.isPassword = false,
  });

  final String hint;
  final IconData iconData;
  final Widget? suffixIcon;
  final bool isPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Password fields start as obscured.
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        enabledBorder: _inputBorder(),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
        ),
        border: _inputBorder(),
        prefixIcon: Icon(widget.iconData, color: Colors.black),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.suffixIcon,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter ${widget.hint.toLowerCase()}';
        }
        return null;
      },
    );
  }

  OutlineInputBorder _inputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
  );
}
