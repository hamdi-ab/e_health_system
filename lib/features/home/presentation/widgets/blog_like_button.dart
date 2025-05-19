import 'package:flutter/material.dart';

class BlogLikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onPressed;
  final int likeCount;

  const BlogLikeButton({
    super.key,
    required this.isLiked,
    required this.onPressed,
    this.likeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLiked ? Colors.red : Colors.grey;
    
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.thumb_up,
        color: color,
      ),
      label: Text(
        likeCount.toString(),
        style: TextStyle(
          color: color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: color,
        ),
      ),
    );
  }
} 