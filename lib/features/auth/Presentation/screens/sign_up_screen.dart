import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../globals.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // 0 for "Patient", 1 for "Doctor"
  int _selectedToggleIndex = 0;
  String? pickedFileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      final file = result.files.first;
      setState(() {
        pickedFileName = file.name;
      });
    }
  }

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
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTitleSection(),
                const SizedBox(height: 16),
                // _buildToggleSection(),
                // const SizedBox(height: 16),
                _buildNameSection(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                // Show the file picker only if account type is "Doctor"
                isDoctorUser
                    ? _buildFilePickerSection()
                    : const SizedBox.shrink(),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 10),
                _buildTermsSection(),
                const SizedBox(height: 20),
                _buildSignUpButton(),
                const SizedBox(height: 16),
                _buildSignInSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section: Title
  Widget _buildTitleSection() {
    return const Text(
      'Sign Up',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 36,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// Section: First Name and Last Name fields
  Widget _buildNameSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(hintText: 'First Name'),
        SizedBox(height: 16),
        CustomTextFormField(hintText: 'Last Name'),
      ],
    );
  }

  /// Section: Email input
  Widget _buildEmailField() {
    return const CustomTextFormField(hintText: 'Email Address');
  }

  /// Section: Toggle for account type ("Patient" vs "Doctor")
  Widget _buildToggleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Toggle(
        labels: const ['Patient', 'Doctor'],
        selectedIndex: _selectedToggleIndex,
        height: 55.0,
        fontSize: 18.0,
        borderRadius: 14.0,
        onToggle: (index) {
          setState(() {
            _selectedToggleIndex = index;
          });
        },
      ),
    );
  }

  /// Section: File Picker (visible only for Doctors)
  Widget _buildFilePickerSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: pickFile,
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: pickedFileName ?? 'Choose File',
                suffixIcon: const Icon(Icons.attach_file),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Section: Password input
  Widget _buildPasswordField() {
    return const CustomTextFormField(
      hintText: 'Enter password',
      obscureText: true,
    );
  }

  /// Section: Confirm password input
  Widget _buildConfirmPasswordField() {
    return const CustomTextFormField(
      hintText: 'Confirm Password',
      obscureText: true,
    );
  }

  /// Section: Terms and Conditions checkbox
  Widget _buildTermsSection() {
    return const TermsCheckbox();
  }

  /// Section: Sign Up button
  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Implement sign-up logic.
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
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  /// Section: Sign In navigation
  Widget _buildSignInSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(fontSize: 17),
        ),
        TextButton(
          onPressed: () {
            context.go('/sign-in');
          },
          child: const Text(
            'Sign in',
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

/// Custom TextFormField for consistent styling
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.obscureText = false,
  });

  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter ${hintText.toLowerCase()}';
        }
        return null;
      },
    );
  }
}

/// Checkbox widget for acceptance of Terms & Conditions
class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({super.key});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _agreed,
          onChanged: (value) {
            setState(() {
              _agreed = value!;
            });
          },
          activeColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreed = !_agreed;
              });
            },
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'I accept all ', style: TextStyle(fontSize: 17)),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Toggle extends StatefulWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onToggle;
  final double height;
  final double fontSize;
  final double borderRadius;

  const Toggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onToggle,
    required this.height,
    required this.fontSize,
    required this.borderRadius,
  });

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  /// Computes the border radius for a segment when it is selected.
  /// The idea is to have rounded outer corners but square (zero-radius) on the inner edge.
  BorderRadius _getSegmentBorderRadius(int index) {
    if (widget.labels.length == 1) {
      return BorderRadius.circular(widget.borderRadius);
    } else if (index == 0) {
      // First segment: round only the left side.
      return BorderRadius.only(
        topLeft: Radius.circular(widget.borderRadius),
        bottomLeft: Radius.circular(widget.borderRadius),
      );
    } else if (index == widget.labels.length - 1) {
      // Last segment: round only the right side.
      return BorderRadius.only(
        topRight: Radius.circular(widget.borderRadius),
        bottomRight: Radius.circular(widget.borderRadius),
      );
    } else {
      // Middle segments have no rounded corners.
      return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Background of the toggle control
        border: Border.all(width: 1.5), // Adds outer border
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Row(
        children: List.generate(widget.labels.length, (index) {
          final isSelected = index == widget.selectedIndex;
          // Only the selected segment gets custom border radius.
          final segmentBorderRadius =
              isSelected ? _getSegmentBorderRadius(index) : BorderRadius.zero;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onToggle(index); // Fire the toggle callback.
              },
              child: Container(
                height: widget.height,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: segmentBorderRadius,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.labels[index],
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
