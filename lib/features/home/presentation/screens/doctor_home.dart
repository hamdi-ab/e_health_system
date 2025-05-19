import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blog/presentation/bloc/blog_bloc.dart';
import '../../../blog/presentation/bloc/blog_event.dart';
import '../../../blog/presentation/bloc/blog_state.dart';
import '../../../blog/domain/entities/blog.dart';
import '../widgets/blog_like_button.dart';
import '../../../blog/presentation/screens/comments_bottom_sheet.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc(
        repository: context.read(),
      )..add(const LoadBlogs()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 16.0),
            _buildAppointmentsSection(),
            const SizedBox(height: 16.0),
            _buildMyBlogsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, Dr. Smith",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Here's your schedule for today",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Appointments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text("John Doe"),
            subtitle: const Text("10:00 AM - General Checkup"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Start"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyBlogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Blogs",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogsLoaded) {
              final myBlogs = state.blogs
                  .where((blog) => blog.authorId == "doctor1")
                  .toList();
              if (myBlogs.isEmpty) {
                return const Center(
                  child: Text("You haven't written any blogs yet"),
                );
              }
              return Column(
                children: myBlogs
                    .map((blog) => _buildBlogCard(context, blog))
                    .toList(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildBlogCard(BuildContext context, Blog blog) {
    const String currentUserId = "doctor1"; // Replace with actual doctor ID
    final bool isLiked =
        blog.blogLikes.any((like) => like.userId == currentUserId);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _ExpandableBlogContent(content: blog.summary),
            const SizedBox(height: 12),
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
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit blog
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Delete blog
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
