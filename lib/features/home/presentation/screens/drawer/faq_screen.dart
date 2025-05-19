import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FAQ list
    final List<Map<String, String>> faqList = [
      {
        "question": "What is E-Health?",
        "answer":
        "E-Health is a digital healthcare platform that enables online consultations, appointment bookings, and secure medical record management.",
      },
      {
        "question": "How do I book an appointment?",
        "answer":
        "You can book an appointment through our online portal or mobile app.",
      },
      {
        "question": "What should I do if I forget my password?",
        "answer":
        "If you forget your password, use the 'Forgot Password' option on the login page to reset it.",
      },
      {
        "question": "Is my data secure?",
        "answer":
        "Yes, we use industry-standard encryption and security measures to protect your data.",
      },
      {
        "question": "Can I access my medical records online?",
        "answer":
        "Yes, you can access your medical records through your profile in our E-Health platform.",
      },
      {
        "question": "What types of consultations are available?",
        "answer":
        "We offer various types of consultations including general practice, specialist consultations, and mental health services.",
      },
      {
        "question": "How do I contact customer support?",
        "answer":
        "You can contact customer support through the 'Contact Us' section on our website or app.",
      },
      {
        "question": "What are the hours of operation?",
        "answer":
        "Our support team is available 24/7 to assist you with any questions or concerns.",
      },
      {
        "question": "Can I change my appointment?",
        "answer":
        "Yes, you can change your appointment through your account settings in the app.",
      },
      {
        "question": "Do you accept insurance?",
        "answer":
        "Yes, we accept various insurance plans. Please check with your provider for details.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Frequently Asked Questions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ Title
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Here are some common questions and answers to help you.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Expandable FAQ List
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  return _buildFAQItem(faqList[index]["question"]!,
                      faqList[index]["answer"]!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build expandable FAQ items
  Widget _buildFAQItem(String question, String answer) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
