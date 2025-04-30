import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../blog/presentation/widgets/expandable_blog_card.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeText(), // Doctor's Welcome
          const SizedBox(height: 16.0),
          _buildAppointmentsSummary(), // Appointment Overview
          const SizedBox(height: 16.0),
          _buildPatientQueueSection(),
          _buildBlogPreview(),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      child: Text(
        "Welcome back, Dr. Hana 👋",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildAppointmentsSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _appointmentCard("Physical Appointments", 4)),
            const SizedBox(width: 16),
            Expanded(child: _appointmentCard("Virtual Appointments", 2)),
          ],
        ),
      ],
    );
  }

  Widget _appointmentCard(String type, int count) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), // Rounded corners
      elevation: 4.0, // Slight shadow for depth
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centers content horizontally
          children: [
            Text(
              "$count",
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center, // Centers text inside the widget
            ),
            const SizedBox(height: 8.0), // Space between count and type
            Text(
              type,
              style: const TextStyle(
                fontSize: 16.0,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center, // Centers text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientQueueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Outside Card
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
          child: Text(
            "Patient",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        const SizedBox(height: 12.0), // Space before the card

        _buildPatientQueueCard(), // Patient Card with Actions
      ],
    );
  }

  Widget _buildPatientQueueCard() {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First Row: Avatar, Name, and Appointment Time
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Abel",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "Virtual Visit",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "3:00 PM",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            // Second Row: Buttons (Start Appointment and Cancel)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Start Appointment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
          child: Text("My Blogs",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text("Write a new post",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
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



