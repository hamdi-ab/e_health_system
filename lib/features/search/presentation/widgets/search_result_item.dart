import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SearchResultItem extends StatelessWidget {
  final String type;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: type == 'doctor' ? AppColors.primary : AppColors.surface,
          child: Icon(
            type == 'doctor' ? Icons.person : Icons.article,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
