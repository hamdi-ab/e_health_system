import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// This widget replicates the HTML modal for a success page.
class OtpSuccessModal extends StatelessWidget {
  const OtpSuccessModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Use a white background with rounded corners.
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Use minimum vertical space.
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular container with a check icon.
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade100, // Light green background.
              ),
              child: const Icon(
                Icons.check,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            // Title: "Success!"
            const Text(
              "Success!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Explanatory text.
            const Text(
              "Congratulation! you have been successfully authenticated",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            // "Continue" button.
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                // Full width button.
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the OTP success modal.
/// Use it like this:
/// showOtpSuccessModal(context);
Future<void> showOtpSuccessModal(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing modal by tapping outside.
    builder: (BuildContext context) {
      return const OtpSuccessModal();
    },
  );
}
