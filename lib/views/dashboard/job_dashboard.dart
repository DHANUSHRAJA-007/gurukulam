import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  _buildHeader(context, viewModel, isDesktop),
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

  // =========================================================
  // HEADER SECTION
  // =========================================================
  Widget _buildHeader(
    BuildContext context,
    JobDashboardViewModel viewModel,
    bool isDesktop,
  ) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
    final timeOfDay = _getTimeOfDay();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Good $timeOfDay!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('👋', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Here\'s what\'s happening with your job search today.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              // Profile Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.teal[400]!, Colors.teal[700]!],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    viewModel.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filter Bar
          _buildFilterBar(context, viewModel, isDesktop),
        ],
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  // =========================================================
  // FILTER BAR
  // =========================================================
  Widget _buildFilterBar(
    BuildContext context,
    JobDashboardViewModel viewModel,
    bool isDesktop,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Search
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  onChanged: viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search jobs...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),
            if (!isDesktop) ...[
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  onPressed: () => _showFilterDialog(context, viewModel),
                  padding: const EdgeInsets.all(10),
                ),
              ),
            ],
          ],
        ),
        if (isDesktop) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              _buildFilterChip(
                label: 'Industry',
                items: viewModel.industries,
                selected: viewModel.selectedIndustry,
                onChanged: viewModel.setIndustryFilter,
              ),
              const SizedBox(width: 12),
              _buildFilterChip(
                label: 'Location',
                items: viewModel.locations,
                selected: viewModel.selectedLocation,
                onChanged: viewModel.setLocationFilter,
              ),
              const Spacer(),
              if (viewModel.selectedIndustry != null ||
                  viewModel.selectedLocation != null)
                TextButton(
                  onPressed: viewModel.clearFilters,
                  child: const Text(
                    'Clear Filters',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
            ],
          ),
        ],
        if (!isDesktop &&
            (viewModel.selectedIndustry != null ||
                viewModel.selectedLocation != null))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                if (viewModel.selectedIndustry != null)
                  _buildSelectedFilterChip(
                    label: viewModel.selectedIndustry!,
                    onDeleted: () => viewModel.setIndustryFilter(null),
                  ),
                if (viewModel.selectedLocation != null) ...[
                  const SizedBox(width: 8),
                  _buildSelectedFilterChip(
                    label: viewModel.selectedLocation!,
                    onDeleted: () => viewModel.setLocationFilter(null),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: viewModel.clearFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip<T>({
    required String label,
    required List<T> items,
    required T? selected,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButton<T>(
        value: selected,
        hint: Text(label),
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: Text(
              'All $label',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ...items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }),
        ],
        onChanged: onChanged,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        style: TextStyle(color: Colors.grey[800], fontSize: 13),
        isDense: true,
      ),
    );
  }

  Widget _buildSelectedFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDeleted,
            child: Icon(Icons.close, size: 14, color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FILTER DIALOG (Mobile)
  // =========================================================
  void _showFilterDialog(
    BuildContext context,
    JobDashboardViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDialogFilter(
                  label: 'Industry',
                  selected: viewModel.selectedIndustry,
                  items: viewModel.industries,
                  onChanged: viewModel.setIndustryFilter,
                ),
                const SizedBox(height: 16),
                _buildDialogFilter(
                  label: 'Location',
                  selected: viewModel.selectedLocation,
                  items: viewModel.locations,
                  onChanged: viewModel.setLocationFilter,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          viewModel.clearFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogFilter<T>({
    required String label,
    required T? selected,
    required List<T> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<T>(
            value: selected,
            hint: Text('Select $label'),
            items: [
              DropdownMenuItem<T>(value: null, child: Text('All $label')),
              ...items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                );
              }),
            ],
            onChanged: onChanged,
            isExpanded: true,
            underline: Container(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // JOB LIST
  // =========================================================
  Widget _buildJobList(JobDashboardViewModel viewModel, bool isDesktop) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  // =========================================================
  // JOB CARD (Mobile)
  // =========================================================
  // Widget _buildJobCard(JobsModel job) {
  //   return Card(
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //       side: BorderSide(color: Colors.grey[200]!, width: 1),
  //     ),
  //     color: Colors.white,
  //     child: InkWell(
  //       onTap: () => _showJobDetails(context, job),
  //       borderRadius: BorderRadius.circular(16),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header: Industry & Location
  //             Row(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //                   decoration: BoxDecoration(
  //                     color: Colors.blue[50],
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Text(
  //                     job.industryName ?? 'Technology',
  //                     style: TextStyle(
  //                       color: Colors.blue[700],
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //                   decoration: BoxDecoration(
  //                     color: Colors.orange[50],
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Text(
  //                     job.location ?? 'Location',
  //                     style: TextStyle(
  //                       color: Colors.orange[700],
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 12),
  //             // Job Title & Company
  //             Text(
  //               job.jobRoleName ?? 'Job Title',
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black87,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               'Company Name',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.grey[600],
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             // Details Row
  //             Row(
  //               children: [
  //                 _buildDetailChip(
  //                   icon: Icons.currency_rupee,
  //                   label: job.salaryRange ?? 'Salary',
  //                 ),
  //                 const SizedBox(width: 12),
  //                 _buildDetailChip(
  //                   icon: Icons.work_outline,
  //                   label: job.experienceRequired ?? 'Experience',
  //                 ),
  //                 const SizedBox(width: 12),
  //                 _buildDetailChip(
  //                   icon: Icons.calendar_today,
  //                   label: job.ageLimit ?? 'Age limit',
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 12),
  //             // Qualifications
  //             if (job.qualificationName != null) ...[
  //               const Text(
  //                 'Minimum Qualification',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 job.qualificationName!,
  //                 style: const TextStyle(fontSize: 13, color: Colors.black87),
  //               ),
  //               const SizedBox(height: 12),
  //             ],
  //             // Employment Details
  //             Row(
  //               children: [
  //                 Icon(
  //                   job.workMode == 'Remote' || job.workMode == 'Hybrid'
  //                       ? Icons.home_work_outlined
  //                       : Icons.business_center_outlined,
  //                   size: 16,
  //                   color: Colors.grey[600],
  //                 ),
  //                 const SizedBox(width: 6),
  //                 Text(
  //                   job.workMode ?? 'On-site',
  //                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
  //                 ),
  //                 const SizedBox(width: 16),
  //                 Icon(
  //                   Icons.access_time_outlined,
  //                   size: 16,
  //                   color: Colors.grey[600],
  //                 ),
  //                 const SizedBox(width: 6),
  //                 Text(
  //                   job.workShiftTiming ?? 'Office hours',
  //                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 12),
  //             // Skills
  //             if (job.skills != null && job.skills!.isNotEmpty) ...[
  //               Wrap(
  //                 spacing: 6,
  //                 runSpacing: 6,
  //                 children: job.skills!.take(4).map((skill) {
  //                   return Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 4,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[100],
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Text(
  //                       skill,
  //                       style: TextStyle(
  //                         fontSize: 11,
  //                         color: Colors.grey[700],
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //               if (job.skills!.length > 4)
  //                 Text(
  //                   '+${job.skills!.length - 4} more',
  //                   style: TextStyle(
  //                     fontSize: 11,
  //                     color: Colors.grey[500],
  //                   ),
  //                 ),
  //               const SizedBox(height: 12),
  //             ],
  //             // Apply Button
  //             SizedBox(
  //               width: double.infinity,
  //               height: 40,
  //               child: ElevatedButton(
  //                 onPressed: () => _showJobDetails(context, job),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.teal[700],
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   elevation: 0,
  //                 ),
  //                 child: const Text(
  //                   'Apply now',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDetailChip({required IconData icon, required String label}) {
  //   return Expanded(
  //     child: Row(
  //       children: [
  //         Icon(icon, size: 14, color: Colors.grey[600]),
  //         const SizedBox(width: 4),
  //         Expanded(
  //           child: Text(
  //             label,
  //             style: TextStyle(fontSize: 12, color: Colors.grey[700]),
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // =========================================================
  // LOADING / ERROR / EMPTY STATES
  // =========================================================
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.teal),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700]),
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

  // =========================================================
  // JOB DETAILS
  // =========================================================
  void _showJobDetails(BuildContext context, JobsModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetails(job: job)),
    );
  }
}
