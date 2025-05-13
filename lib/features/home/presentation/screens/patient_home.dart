import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../blog/presentation/widgets/expandable_blog_card.dart';
import '../../../search/presentation/screens/search_result_screen.dart';
import '../../../search/presentation/widgets/filter_modal_widgets.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(context), // Search Bar
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

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: "Search doctors by name, specialty…",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune), // Filter icon
            onPressed: () {
              // Handle filter action
              showFilterModal(context);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onSubmitted: (query) {
          // When the user submits their search (presses the enter key), navigate to the search results screen.
          if (query.trim().isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchResultScreen(query: query),
              ),
            );
          }
        });
  }

// Helper method for Specialty Icons with Circle Avatar
  Widget _specialtyCircle(String title, IconData icon) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Adds vertical spacing
      child: Column(
        children: [
          CircleAvatar(
            radius: 30, // Adjust size as needed
            backgroundColor:
                AppColors.primary.withOpacity(0.2), // Light background
            child: Icon(icon,
                color: AppColors.primary, size: 28), // Specialty Icon
          ),
          const SizedBox(height: 8), // More space between icon and text
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

// Builds Specialty Section with Horizontal Scroll
  Widget _buildSpecialtySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specialties",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12), // Added spacing between title and chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Padding for better visual alignment
            child: Row(
              children: [
                _specialtyCircle("Cardiology", Icons.favorite_rounded), // Heart
                const SizedBox(width: 16), // Space between elements
                _specialtyCircle("Pediatrics", Icons.child_care), // Child icon
                const SizedBox(width: 16),
                _specialtyCircle(
                    "Dermatology", Icons.spa), // Skincare/natural remedies
                const SizedBox(width: 16),
                _specialtyCircle("Neurology", Icons.psychology), // Brain icon
                const SizedBox(width: 16),
                _specialtyCircle(
                    "Orthopedics", Icons.accessibility_new), // Bone/joint care
                const SizedBox(width: 16),
                _specialtyCircle(
                    "Oncology", Icons.local_hospital), // Cancer care/hospital
                const SizedBox(width: 16),
                _specialtyCircle(
                    "Gynecology", Icons.pregnant_woman), // Women's health
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopRatedDoctors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Top Rated Doctors",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        _doctorCard("Dr. A", "Cardiology", 4.8,
            "Experienced cardiologist specializing in heart health and preventive care."),
        _doctorCard("Dr. B", "Pediatrics", 4.7,
            "Passionate about children's health, with over 10 years in pediatric medicine."),
        _doctorCard("Dr. C", "Dermatology", 4.9,
            "Expert in skin disorders, treatments, and cosmetic dermatology procedures."),
      ],
    );
  }

  Widget _doctorCard(
      String name, String specialty, double rating, String description) {
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
                  child: Icon(Icons.person,
                      size: 40, color: Colors.white), // Icon color optimized
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: AppColors.primary)),
                      Text(specialty,
                          style: const TextStyle(
                              fontSize: 18, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "★★★★★",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 5), // Adds some spacing
                    Text(
                      "($rating)",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                )
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
                    style: const TextStyle(
                        fontSize: 14.0, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child:
                      const Text("Book", style: TextStyle(color: Colors.white)),
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
    return Column(
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
