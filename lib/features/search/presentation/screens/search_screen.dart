import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/filter_modal_widgets.dart';
import '../widgets/search_result_item.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;
  final String? category;

  const SearchScreen({
    super.key,
    this.initialQuery = '',
    this.category,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    if (widget.initialQuery.isNotEmpty) {
      context.read<SearchBloc>().add(
            SearchQueryChanged(
              widget.initialQuery,
              category: widget.category,
            ),
          );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search doctors, blogs...",
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<SearchBloc>().add(const ClearSearch());
              },
            ),
          ),
          onChanged: (query) {
            context.read<SearchBloc>().add(
                  SearchQueryChanged(
                    query,
                    category: widget.category,
                  ),
                );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => showFilterModal(context),
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Text('Start typing to search...'),
            );
          }

          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SearchError) {
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
                      context.read<SearchBloc>().add(
                            SearchQueryChanged(
                              _searchController.text,
                              category: widget.category,
                            ),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SearchResults) {
            if (state.doctors.isEmpty && state.blogs.isEmpty) {
              return const Center(
                child: Text('No results found'),
              );
            }

            return ListView(
              controller: _scrollController,
              children: [
                if (state.doctors.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Doctors',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...state.doctors.map((doctor) => SearchResultItem(
                        type: 'doctor',
                        title: '${doctor.user.firstName} ${doctor.user.lastName}',
                        subtitle: doctor.qualifications,
                        onTap: () {
                          // Navigate to doctor details
                        },
                      )),
                ],
                if (state.blogs.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Blogs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...state.blogs.map((blog) => SearchResultItem(
                        type: 'blog',
                        title: blog.title,
                        subtitle: blog.summary,
                        onTap: () {
                          // Navigate to blog details
                        },
                      )),
                ],
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
} 