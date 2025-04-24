import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ExpandableBlogCard extends StatefulWidget {
  final String title;
  const ExpandableBlogCard({super.key, required this.title});

  @override
  State<ExpandableBlogCard> createState() => ExpandableBlogCardState();
}

class ExpandableBlogCardState extends State<ExpandableBlogCard> {
  bool _isExpanded = false;
  // Here you can adjust the content for different blog posts as needed.
  final String _content =
      "Heart disease is a major cause of death worldwide. It involves a diverse range of conditions that affect your heart. Early detection and lifestyle changes can help prevent complications. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor info and date
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Dr. Workaba",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " (Cardiologist) | March 6, 2025"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Blog Title using the passed title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Blog Content with expandable text
            Text(
              _content,
              style: const TextStyle(fontSize: 14),
              maxLines: _isExpanded ? null : 2,
              overflow:
              _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            // "See More" / "Show Less" link
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _isExpanded ? "Show Less" : "See More",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Blog Footer with Like and Comment Buttons
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up, color: Colors.red),
                  label: const Text("3", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text("💬 Comments 0",
                      style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}