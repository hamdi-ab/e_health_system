import 'package:e_health_system/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/otp_success_modal.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Controllers for each of the OTP input fields.
  final TextEditingController _otp1Controller = TextEditingController();
  final TextEditingController _otp2Controller = TextEditingController();
  final TextEditingController _otp3Controller = TextEditingController();
  final TextEditingController _otp4Controller = TextEditingController();

  // FocusNodes for each of the OTP fields.
  final FocusNode _otp1Focus = FocusNode();
  final FocusNode _otp2Focus = FocusNode();
  final FocusNode _otp3Focus = FocusNode();
  final FocusNode _otp4Focus = FocusNode();

  @override
  void dispose() {
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();
    _otp1Focus.dispose();
    _otp2Focus.dispose();
    _otp3Focus.dispose();
    _otp4Focus.dispose();
    super.dispose();
  }

  // Updated OTP text field with auto-focus functionality.
  Widget _buildOtpTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
  }) {
    return SizedBox(
      width: 60,
      height: 80, // Increased height
      child: TextField(
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        controller: controller,
        focusNode: focusNode, // Attach the focus node.
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            // If a value is entered, move focus to the next field if available.
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              focusNode.unfocus();
            }
          }
        },
        decoration: InputDecoration(
          counterText: '', // Hides the character counter.
          contentPadding: const EdgeInsets.symmetric(vertical: 24.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  // Concatenate the OTP fields and print (or verify) the OTP.
  void _verifyOtp() async {
    String otp = _otp1Controller.text +
        _otp2Controller.text +
        _otp3Controller.text +
        _otp4Controller.text;
    print("Entered OTP: $otp");
    // TODO: Add verification logic here.

    // TODO: Replace this with your actual validation logic.
    // For demonstration, let's consider "1234" as the valid OTP.
    if (otp == "1234") {
      // Show the OTP success modal.
      await showOtpSuccessModal(context);
      // After the modal is dismissed, navigate to the next screen.
      // For example, pushReplacement to the home screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // If OTP is invalid, show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally, wrap with SafeArea.
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back arrow button.
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Title: Verification Code
                const Text(
                  "Verification Code",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Explanation text.
                const Text(
                  "We have sent the verification code to your email address",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                // 'Enter OTP' label.
                const Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Row containing the 4 OTP input fields with automatic focus change.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpTextField(
                      controller: _otp1Controller,
                      focusNode: _otp1Focus,
                      nextFocus: _otp2Focus,
                    ),
                    _buildOtpTextField(
                      controller: _otp2Controller,
                      focusNode: _otp2Focus,
                      nextFocus: _otp3Focus,
                    ),
                    _buildOtpTextField(
                      controller: _otp3Controller,
                      focusNode: _otp3Focus,
                      nextFocus: _otp4Focus,
                    ),
                    _buildOtpTextField(
                      controller: _otp4Controller,
                      focusNode: _otp4Focus,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // "Verify OTP" button.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Optionally add additional spacing or instructions here.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
