import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Welcome to E-Health",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We are committed to transforming healthcare through technology, providing seamless access to medical services.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Mission Statement
            _buildSectionTitle("Our Mission"),
            const Text(
              "Our mission is to empower individuals with easy access to healthcare professionals, secure medical records, and online consultations.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Key Features Section
            _buildSectionTitle("What We Offer"),
            _buildFeatureItem(
              icon: Icons.calendar_today,
              title: "Online Appointments",
              description: "Book consultations with doctors anytime, anywhere.",
            ),
            _buildFeatureItem(
              icon: Icons.security,
              title: "Secure Medical Records",
              description: "Access your health history safely and privately.",
            ),
            _buildFeatureItem(
              icon: Icons.support_agent,
              title: "24/7 Support",
              description: "Our customer service is always available to help you.",
            ),
            _buildFeatureItem(
              icon: Icons.health_and_safety,
              title: "Various Specialties",
              description: "Consult with professionals in different medical fields.",
            ),
            const SizedBox(height: 16),

            // Contact Us Section
            _buildSectionTitle("Contact Us"),
            const Text(
              "📧 Email: support@ehealth.com\n📞 Phone: +251900000000\n🌍 Website: www.ehealth.com",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Builder
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Feature Item Builder
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
