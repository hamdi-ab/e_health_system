import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:e_health_system/features/home/presentation/screens/doctor_profile_screen.dart';
import 'package:e_health_system/features/search/data/repositories/doctor_repository.dart';
import 'package:e_health_system/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blog/presentation/bloc/blog_bloc.dart';
import '../../../blog/presentation/bloc/blog_event.dart';
import '../../../blog/presentation/bloc/blog_state.dart';
import '../../../blog/domain/entities/blog.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../search/presentation/widgets/filter_modal_widgets.dart';
import '../widgets/blog_like_button.dart';
import '../../../blog/presentation/screens/comments_bottom_sheet.dart';
import '../screens/specialty_doctors_screen.dart';
import 'package:go_router/go_router.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
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
            _buildSearchBar(context),
            const SizedBox(height: 16.0),
            _buildSpecialtySection(context),
            const SizedBox(height: 16.0),
            _buildTopRatedDoctors(),
            const SizedBox(height: 16.0),
            _buildUpcomingAppointments(),
            const SizedBox(height: 16.0),
            _buildRecentBlogs()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        hintText: "Search doctors by name, specialty…",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () {
            showFilterModal(context);
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onSubmitted: (query) {
        if (query.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchScreen(initialQuery: query),
            ),
          );
        }
      },
      textInputAction: TextInputAction.search,
      readOnly: false,
    );
  }

// Helper method for Specialty Icons with Circle Avatar
  Widget _specialtyCircle(
      String title, IconData icon, String specialtyId, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/specialty/$specialtyId');
      },
      child: Padding(
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
      ),
    );
  }

// Builds Specialty Section with Horizontal Scroll
  Widget _buildSpecialtySection(BuildContext context) {
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
                _specialtyCircle("Cardiology", Icons.favorite_rounded, "sp1",
                    context), // Heart
                const SizedBox(width: 16), // Space between elements
                _specialtyCircle("Pediatrics", Icons.child_care, "sp2",
                    context), // Child icon
                const SizedBox(width: 16),
                _specialtyCircle("Dermatology", Icons.spa, "sp3",
                    context), // Skincare/natural remedies
                const SizedBox(width: 16),
                _specialtyCircle("Neurology", Icons.psychology, "sp4",
                    context), // Brain icon
                const SizedBox(width: 16),
                _specialtyCircle("Orthopedics", Icons.accessibility_new, "sp5",
                    context), // Bone/joint care
                const SizedBox(width: 16),
                _specialtyCircle("Oncology", Icons.local_hospital, "sp6",
                    context), // Cancer care/hospital
                const SizedBox(width: 16),
                _specialtyCircle("Gynecology", Icons.pregnant_woman, "sp7",
                    context), // Women's health
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
      color: AppColors.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          final matchingDoctors = await _getDoctorsBySpecialty(specialty);
          if (matchingDoctors.isNotEmpty && mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorProfileScreen(
                  doctorId: matchingDoctors.first.doctorId,
                  doctor: matchingDoctors.first,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.white),
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
                      const SizedBox(width: 5),
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
                    onPressed: () async {
                      final matchingDoctors = await _getDoctorsBySpecialty(specialty);
                      if (matchingDoctors.isNotEmpty && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorProfileScreen(
                              doctorId: matchingDoctors.first.doctorId,
                              doctor: matchingDoctors.first,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text("Book",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get doctors by specialty name
  Future<List<Doctor>> _getDoctorsBySpecialty(String specialtyName) async {
    // Map specialty names to specialty IDs
    final specialtyIds = {
      'Cardiology': 'sp1',
      'Pediatrics': 'sp2',
      'Dermatology': 'sp3',
      'Neurology': 'sp4',
      'Orthopedics': 'sp5',
      'Oncology': 'sp6',
      'Gynecology': 'sp7',
    };

    final specialtyId = specialtyIds[specialtyName];
    if (specialtyId == null) return [];

    try {
      final doctors = await RepositoryProvider.of<DoctorRepository>(context)
          .fetchDoctorsBySpeciality(specialtyId);
      return doctors;
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
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
        const Text(
          "Recent Blogs",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogsLoaded) {
              final blogs =
                  state.blogs.take(2).toList(); // Show only 2 recent blogs
              return Column(
                children:
                    blogs.map((blog) => _buildBlogCard(context, blog)).toList(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Widget _buildBlogCard(BuildContext context, Blog blog) {
    const String currentUserId = "user1"; // Replace with actual user ID
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
            // Author info
            Text(
              "by ${blog.author != null ? '${blog.author!.firstName} ${blog.author!.lastName}' : 'Unknown'} | ${blog.authorId}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              blog.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Content with See More
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
                    CommentsBottomSheet.show(context, blog);
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
}

// Add expandable content widget
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
