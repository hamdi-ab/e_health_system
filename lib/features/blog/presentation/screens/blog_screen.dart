import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/blog.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../bloc/blog_state.dart';
import 'add_blog_screen.dart';
import 'comments_bottom_sheet.dart';
import '../../../home/presentation/widgets/blog_like_button.dart';

// ---------- BlogPage using _build methods ----------

class BlogScreen extends StatelessWidget {
  final bool isDoctor;
  const BlogScreen({super.key, required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc(
        repository: context.read(),
      )..add(const LoadBlogs()),
      child: Scaffold(
        body: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlogError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BlogBloc>().add(const LoadBlogs());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is BlogsLoaded) {
              return _buildBlogContent(context, state.blogs);
            }

            return const Center(child: Text('No blogs available'));
          },
        ),
        floatingActionButton:
            isDoctor ? _buildFloatingActionButton(context) : null,
      ),
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
          if (featuredBlog != null)
            _buildFeaturedBlogSection(context, featuredBlog),
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
        onChanged: (query) {
          if (query.isEmpty) {
            context.read<BlogBloc>().add(const ClearSearch());
          } else {
            context.read<BlogBloc>().add(SearchBlogs(query));
          }
        },
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
    final bool isLiked =
        blog.blogLikes.any((like) => like.userId == currentUserId);

    return Card(
      color: AppColors.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                _ExpandableBlogContent(content: blog.summary),
                const SizedBox(height: 16),
                Row(
                  children: [
                    BlogLikeButton(
                      isLiked: isLiked,
                      likeCount: blog.blogLikes.length,
                      onPressed: () {
                        context.read<BlogBloc>().add(ToggleLike(
                              blogId: blog.blogId,
                              userId: currentUserId,
                            ));
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        _showCommentsSheet(context, blog);
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
                      // TODO: Navigate to Blog Detail Page
                    },
                    child:
                        const Text("Read More", style: TextStyle(fontSize: 16)),
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
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if (state is BlogsLoaded) {
          final blogs = state.filteredBlogs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Latest Blogs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...blogs.map((blog) => _buildBlogCard(context, blog)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBlogCard(BuildContext context, Blog blog) {
    const String currentUserId = "user1";
    final bool isLiked =
        blog.blogLikes.any((like) => like.userId == currentUserId);

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
                    text: blog.author != null
                        ? '${blog.author!.firstName} ${blog.author!.lastName}'
                        : 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " | ${blog.authorId}"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              blog.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _ExpandableBlogContent(content: blog.summary),
            const SizedBox(height: 16),
            Row(
              children: [
                BlogLikeButton(
                  isLiked: isLiked,
                  likeCount: blog.blogLikes.length,
                  onPressed: () {
                    context.read<BlogBloc>().add(ToggleLike(
                          blogId: blog.blogId,
                          userId: currentUserId,
                        ));
                  },
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    _showCommentsSheet(context, blog);
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

  void _showCommentsSheet(BuildContext context, Blog blog) {
    CommentsBottomSheet.show(context, blog);
  }
}

/// ---------- Expandable Blog Content Widget ----------
class _ExpandableBlogContent extends StatefulWidget {
  final String content;
  const _ExpandableBlogContent({required this.content});

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
