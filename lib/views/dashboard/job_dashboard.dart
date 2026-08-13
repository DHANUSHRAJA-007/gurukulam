import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/job_model.dart';
import '../../viewModels/job_dashboard_viewmodel.dart';
import 'job_card.dart';
import 'job_card_desktop.dart';
import 'job_detail_view.dart';

class JobDashboard extends StatefulWidget {
  const JobDashboard({super.key});

  @override
  State<JobDashboard> createState() => _JobDashboardState();
}

class _JobDashboardState extends State<JobDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobDashboardViewModel>().fetchJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Consumer<JobDashboardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return _buildLoadingState();
          }

          if (viewModel.error != null) {
            return _buildErrorState(viewModel.error!);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 768;
              return Column(
                children: [
                  _buildFilterBar(context, viewModel, isDesktop),
                  Expanded(
                    child: viewModel.jobs.isEmpty
                        ? _buildEmptyState()
                        : _buildJobList(viewModel, isDesktop),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Afternoon, Sarah Johnson! 🎉',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Text(
            'Welcome back! Here\'s what\'s happening with your job search today.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(
              'SJ',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 16),
          Text('Loading jobs...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error loading jobs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<JobDashboardViewModel>().fetchJobs();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    JobDashboardViewModel viewModel,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: isDesktop ? 3 : 1,
            child: TextField(
              onChanged: viewModel.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filters
          if (isDesktop) ...[
            _buildFilterDropdown(
              context,
              value: viewModel.selectedIndustry,
              items: viewModel.industries,
              hint: 'Industry',
              onChanged: viewModel.setIndustryFilter,
            ),
            const SizedBox(width: 12),
            _buildFilterDropdown(
              context,
              value: viewModel.selectedLocation,
              items: viewModel.locations,
              hint: 'Location',
              onChanged: viewModel.setLocationFilter,
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: viewModel.clearFilters,
              child: const Text('Clear Filters'),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context, viewModel),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>(
    BuildContext context, {
    required T? value,
    required List<T> items,
    required String hint,
    required Function(T?) onChanged,
  }) {
    return DropdownButton<T>(
      value: value,
      hint: Text(hint),
      items: [
        DropdownMenuItem<T>(value: null, child: Text('All $hint')),
        ...items.map((item) {
          return DropdownMenuItem<T>(value: item, child: Text(item.toString()));
        }),
      ],
      onChanged: onChanged,
      underline: Container(),
      icon: const Icon(Icons.arrow_drop_down),
      style: TextStyle(color: Colors.grey[800], fontSize: 14),
    );
  }

  void _showFilterDialog(
    BuildContext context,
    JobDashboardViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: viewModel.selectedIndustry,
                hint: const Text('Industry'),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Industries'),
                  ),
                  ...viewModel.industries.map((industry) {
                    return DropdownMenuItem<String>(
                      value: industry,
                      child: Text(industry),
                    );
                  }),
                ],
                onChanged: viewModel.setIndustryFilter,
                isExpanded: true,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: viewModel.selectedLocation,
                hint: const Text('Location'),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Locations'),
                  ),
                  ...viewModel.locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }),
                ],
                onChanged: viewModel.setLocationFilter,
                isExpanded: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.clearFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[800],
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobList(JobDashboardViewModel viewModel, bool isDesktop) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.jobs.length,
      itemBuilder: (context, index) {
        final job = viewModel.jobs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: isDesktop
              ? JobCardDesktop(
                  job: job,
                  onTap: () => _showJobDetails(context, job),
                )
              : JobCard(job: job, onTap: () => _showJobDetails(context, job)),
        );
      },
    );
  }

  void _showJobDetails(BuildContext context, JobsModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetails(job: job)),
    );
  }
}
