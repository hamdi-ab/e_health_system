import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

// ---------- Model for Blog posts ----------
class Blog {
  final String title;
  final String author;
  final String specialty;
  final String datePosted;
  final String snippet;
  final String imageUrl;
  final String content;

  Blog({
    required this.title,
    required this.author,
    required this.specialty,
    required this.datePosted,
    required this.snippet,
    required this.imageUrl,
    required this.content,
  });
}

// ---------- BlogPage using _build methods ----------
class BlogScreen extends StatelessWidget {
  final bool isDoctor;
  const BlogScreen({Key? key, required this.isDoctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy Data:
    final Blog featuredBlog = Blog(
      title: "Heart Health: A Comprehensive Guide",
      author: "Dr. Elias",
      specialty: "Cardiologist",
      datePosted: "Mar 3, 2025",
      snippet:
      "Heart health is more than just avoiding disease—it’s about proactive care and a vibrant lifestyle. Learn how to keep your heart healthy...",
      imageUrl: "assets/article-min-edited-scaled.jpg",
      content: "Full article content here...",
    );

    final List<Blog> blogList = [
      Blog(
        title: "Skincare in Dry Climates",
        author: "Dr. Hana",
        specialty: "Dermatologist",
        datePosted: "Feb 28, 2025",
        snippet:
        "Skincare in dry climates requires special attention. Discover hydration tips and protective routines for your skin...",
        imageUrl: "assets/article-min-edited-scaled.jpg",
        content: "Full article content here...",
      ),
      Blog(
        title: "Nutrition and Longevity",
        author: "Dr. Smith",
        specialty: "Nutritionist",
        datePosted: "Feb 20, 2025",
        snippet:
        "Balanced nutrition is key to a long and healthy life. Explore the secrets behind a diet that promotes longevity...",
        imageUrl: "assets/article-min-edited-scaled.jpg",
        content: "Full article content here...",
      ),
      // ... add more blogs as needed.
    ];

    return Scaffold(
      // appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            _buildFeaturedBlogSection(context, featuredBlog),
            _buildBlogListSection(context, blogList),
          ],
        ),
      ),
      floatingActionButton: isDoctor ? _buildFloatingActionButton(context) : null,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Health Blog"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Implement search functionality.
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search blog posts...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// Featured Blog Section with a tweaked card for extra importance.
  Widget _buildFeaturedBlogSection(BuildContext context, Blog blog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Featured Blog",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildFeaturedBlogCard(context, blog),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Featured Blog Card – larger image, more padding, and like/comment footer.
  Widget _buildFeaturedBlogCard(BuildContext context, Blog blog) {
    return Card(
      color: AppColors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Image – larger height.
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              blog.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author Info and Date
                Text(
                  "by ${blog.author} (${blog.specialty}) | ${blog.datePosted}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Blog Title
                Text(
                  blog.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                // Blog Snippet using expandable content.
                _ExpandableBlogContent(content: blog.snippet),
                const SizedBox(height: 16),
                // Like and Comment Footer.
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Handle like toggle.
                      },
                      icon: const Icon(Icons.thumb_up, color: Colors.red),
                      label: const Text("3", style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to comments.
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text("💬 Comments 0", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // "Read More" button aligned to the right.
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to Blog Detail Page.
                    },
                    child: const Text("Read More", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Latest Blog List Section using the Expandable style.
  Widget _buildBlogListSection(BuildContext context, List<Blog> blogList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Latest Blogs",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...blogList.map((blog) => _buildBlogCard(context, blog)),
      ],
    );
  }

  /// Latest Blog Card using an expandable content area similar to ExpandableBlogCard.
  Widget _buildBlogCard(BuildContext context, Blog blog) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Thumbnail.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                blog.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            // Blog Header: Title and Author Info.
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: "by ${blog.author}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " (${blog.specialty}) | ${blog.datePosted}"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              blog.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            // Expandable Content for the snippet.
            _ExpandableBlogContent(content: blog.snippet),
            const SizedBox(height: 16),
            // Like and Comment Footer.
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Handle like toggle.
                  },
                  icon: const Icon(Icons.thumb_up, color: Colors.red),
                  label: const Text("3", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to comments.
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text("💬 Comments 0", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Floating Action Button for doctors to write a new blog post.
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Open blog editor screen.
      },
      child: const Icon(Icons.add),
    );
  }
}

/// ---------- Expandable Blog Content Widget ----------
class _ExpandableBlogContent extends StatefulWidget {
  final String content;
  const _ExpandableBlogContent({Key? key, required this.content}) : super(key: key);

  @override
  __ExpandableBlogContentState createState() => __ExpandableBlogContentState();
}

class __ExpandableBlogContentState extends State<_ExpandableBlogContent> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.content,
          style: const TextStyle(fontSize: 14),
          maxLines: _isExpanded ? null : 2,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
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
      ],
    );
  }
}
