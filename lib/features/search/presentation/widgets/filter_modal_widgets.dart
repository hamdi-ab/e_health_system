import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({super.key});

  @override
  _FilterModalWidgetState createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  // State variables for filter selections
  final Map<String, bool> _selectedFilters = {
    "Cardiologist": false,
    "Dentist": false,
    "English": false,
    "Amharic": false,
    "Oromiffa": false,
    "Male": false,
    "Female": false,
    "Other": false,
  };

  void _toggleFilter(String key) {
    setState(() {
      _selectedFilters[key] = !_selectedFilters[key]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter Options",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                // Specialty Section
                _buildFilterSection("Specialty", ["Cardiologist", "Dentist"]),
                _buildFilterSection("Languages", ["English", "Amharic", "Oromiffa"]),
                _buildFilterSection("Gender", ["Male", "Female", "Other"]),
                const SizedBox(height: 24.0),
                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Handle filter application logic
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                    child: const Text("Apply Filters"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> filters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: filters.map((filter) {
            return FilterChip(
              label: Text(filter),
              selected: _selectedFilters[filter]!,
              onSelected: (selected) => _toggleFilter(filter),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

// Usage: Call this function from your main screen to show the modal.
void showFilterModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterModalWidget(),
  );
}
