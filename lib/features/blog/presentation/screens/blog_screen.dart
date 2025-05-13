import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/blog.dart';
import '../provider/blog_notifier.dart';
import 'add_blog_screen.dart';
import 'comment_screen.dart';

// ---------- BlogPage using _build methods ----------

class BlogScreen extends ConsumerStatefulWidget {
  final bool isDoctor;
  const BlogScreen({Key? key, required this.isDoctor}) : super(key: key);

  @override
  ConsumerState<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends ConsumerState<BlogScreen> {
  @override
  void initState() {
    super.initState();
    // Load blogs after the first frame is rendered to avoid calling ref.read during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(blogNotifierProvider).loadBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.watch to listen to changes on blogNotifierProvider.
    final blogNotifier = ref.watch(blogNotifierProvider);

    return Scaffold(
      body: blogNotifier.isLoading
          ? const Center(child: CircularProgressIndicator())
          : blogNotifier.error != null
          ? Center(child: Text('Error: ${blogNotifier.error}'))
          : _buildBlogContent(context, blogNotifier.blogs),
      floatingActionButton: widget.isDoctor ? _buildFloatingActionButton(context) : null,
    );
  }

  Widget _buildBlogContent(BuildContext context, List<Blog> blogs) {
    final Blog? featuredBlog = blogs.isNotEmpty ? blogs.first : null;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(context),
          if (featuredBlog != null) _buildFeaturedBlogSection(context, featuredBlog),
          _buildBlogListSection(context, blogs),
        ],
      ),
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

  Widget _buildFeaturedBlogCard(BuildContext context, Blog blog) {
    const String currentUserId = "user1";

// Check if current user has liked this blog.
    final bool isLiked = blog.blogLikes.any((like) => like.userId == currentUserId);
    return Card(
      color: AppColors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured image.
          // ClipRRect(
          //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          //   child: Image.asset(
          //     blog.imageUrl,
          //     height: 220,
          //     width: double.infinity,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "by ${blog.author != null ? '${blog.author!.firstName} ${blog.author!.lastName}' : 'Unknown'} | ${blog.authorId}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                _ExpandableBlogContent(content: blog.summary),
                const SizedBox(height: 16),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Toggle like status.
                        ref.read(blogNotifierProvider.notifier).toggleLike(blog.blogId, currentUserId);
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      label: Text(
                        blog.blogLikes.length.toString(),
                        style: TextStyle(color: isLiked ? Colors.red : Colors.grey),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isLiked ? Colors.red : Colors.grey),
                      ),
                    ),

                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        // Navigate to the CommentsScreen, passing the current blog.
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(blog: blog),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: Text(
                        "💬 Comments ${blog.blogComments.length}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),


                  ],
                ),
                const SizedBox(height: 8),
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

  Widget _buildBlogCard(BuildContext context, Blog blog) {
    const String currentUserId = "user1";
    // Check if current user has liked this blog.
    final bool isLiked = blog.blogLikes.any((like) => like.userId == currentUserId);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: blog.author != null ? '${blog.author!.firstName} ${blog.author!.lastName}' : 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " | ${blog.authorId}"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image.asset(
            //     blog.imageUrl,
            //     height: 180,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // const SizedBox(height: 12),
            Text(
              blog.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _ExpandableBlogContent(content: blog.summary),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Toggle like status.
                    ref.read(blogNotifierProvider.notifier).toggleLike(blog.blogId, currentUserId);
                  },
                  icon: Icon(
                    Icons.thumb_up,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  label: Text(
                    blog.blogLikes.length.toString(),
                    style: TextStyle(color: isLiked ? Colors.red : Colors.grey),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isLiked ? Colors.red : Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to comments.
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(blog: blog),
                        ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: Text(
                    "💬 Comments ${blog.blogComments.length}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  // Inside your BlogScreen widget:
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddBlogScreen()),
        );
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
