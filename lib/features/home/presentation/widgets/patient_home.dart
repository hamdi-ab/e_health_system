import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../blog/presentation/widgets/expandable_blog_card.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(), // Search Bar
          const SizedBox(height: 16.0),
          _buildSpecialtySection(), // Specialty Categories
          const SizedBox(height: 16.0),
          _buildTopRatedDoctors(), // Top Rated Doctors
          const SizedBox(height: 16.0),
          _buildUpcomingAppointments(), // Upcoming Appointments
          const SizedBox(height: 16.0),
          _buildRecentBlogs()
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: "Search doctors by name, specialty…",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list), // Filter icon
          onPressed: () {
            // Handle filter action
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  // Method for Specialty Section
  Widget _buildSpecialtySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specialties",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _specialtyChip("Cardiology"),
              _specialtyChip("Pediatrics"),
              _specialtyChip("Dermatology"),
              _specialtyChip("Neurology"),
              _specialtyChip("Orthopedics"),
              _specialtyChip("Oncology"),
              _specialtyChip("Gynecology"),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method for Specialty Chips
  Widget _specialtyChip(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(
          title,
          style: const TextStyle(color: Colors.white), // High contrast text
        ),
        backgroundColor: AppColors.primary.withAlpha(200), // Light transparent shade
      ),
    );
  }

  Widget _buildTopRatedDoctors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Top Rated Doctors", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        _doctorCard("Dr. A", "Cardiology", 4.8, "Experienced cardiologist specializing in heart health and preventive care."),
        _doctorCard("Dr. B", "Pediatrics", 4.7, "Passionate about children's health, with over 10 years in pediatric medicine."),
        _doctorCard("Dr. C", "Dermatology", 4.9, "Expert in skin disorders, treatments, and cosmetic dermatology procedures."),
      ],
    );
  }

  Widget _doctorCard(String name, String specialty, double rating, String description) {
    return Card(
      elevation: 3.0,
      color: AppColors.surface, // Background color matches app theme
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary, // Matches theme
                  child: Icon(Icons.person, size: 40, color: Colors.white), // Icon color optimized
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: AppColors.primary)),
                      Text(specialty, style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text("★ $rating", style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.0, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),),
                  child: const Text("Book", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  // Upcoming Appointments
  Widget _buildUpcomingAppointments() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upcoming Appointments",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Card(
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Dr. Hana"),
            subtitle: Text("Appointment at 3PM today"),
          ),
        ),
      ],
    );
  }

  // Recent Blogs
  Widget _buildRecentBlogs() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Blogs",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        _blogPost("Managing patient records efficiently"),
        _blogPost("Best practices in online consultations"),
      ],
    );
  }

  Widget _blogPost(String title) {
    return ExpandableBlogCard(title: title);
  }
}
