import 'package:flutter/material.dart';
import 'package:gurukulam/views/dashboard/widget.dart';
import 'package:provider/provider.dart';

import '../../models/job_model.dart';
import '../../models/master_model.dart';
import '../../viewModels/job_dashboard_viewmodel.dart';
import 'job_detail_view.dart';

class JobDashboard extends StatefulWidget {
  const JobDashboard({super.key});

  @override
  State<JobDashboard> createState() => _JobDashboardState();
}

class _JobDashboardState extends State<JobDashboard> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final Set<int> _bookmarked = {};

  static const List<List<Color>> _accentGradients = [
    [Color(0xFF14B8A6), Color(0xFF0891B2)],
    [Color(0xFF8B5CF6), Color(0xFF6366F1)],
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobDashboardViewModel>().fetchJobs();
    });
  }

  @override
  void dispose() {
    _roleController.dispose();
    _industryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Consumer<JobDashboardViewModel>(
        builder: (context, viewModel, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 768;
              return SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 16,
                    vertical: isDesktop ? 32 : 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 1400 : 600,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildGreetingHeader(isDesktop, viewModel),
                          const SizedBox(height: 20),
                          _buildOpeningsPanel(context, viewModel, isDesktop),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOpeningsPanel(
    BuildContext context,
    JobDashboardViewModel viewModel,
    bool isDesktop,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 28 : 18,
            isDesktop ? 24 : 16,
            isDesktop ? 28 : 18,
            isDesktop ? 24 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: isDesktop ? const Radius.circular(20) : Radius.zero,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7F1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.work_outline,
                          size: 18,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Available Job Openings',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  if (isDesktop)
                    Row(
                      children: [
                        if (viewModel.selectedIndustry != null ||
                            viewModel.selectedLocation != null ||
                            _roleController.text.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              viewModel.clearFilters();
                              _roleController.clear();
                              _industryController.clear();
                              _locationController.clear();
                              viewModel.setSearchQuery('');
                              setState(() {});
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              'Clear Filters',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: () => _showFilterDialog(context, viewModel),
                      icon: const Icon(Icons.filter_list, size: 16),
                      label: const Text('Filters'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D9488),
                        side: const BorderSide(color: Color(0xFFD1FAE5)),
                        backgroundColor: const Color(0xFFF0FDF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                    ),
                ],
              ),
              if (isDesktop) ...[
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildLabeledField(
                        label: 'Role',
                        required: true,
                        controller: _roleController,
                        hint: 'e.g. Frontend Engineer',
                        onChanged: (v) {
                          viewModel.setSearchQuery(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildLabeledField(
                        label: 'Industry',
                        required: true,
                        controller: _industryController,
                        hint: 'e.g. Technology',
                        onChanged: (v) {
                          viewModel.setSearchQuery(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildLabeledField(
                        label: 'Location',
                        required: true,
                        controller: _locationController,
                        hint: 'e.g. Bengaluru',
                        onChanged: (v) {
                          viewModel.setSearchQuery(v);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        if (viewModel.isLoading)
          _buildLoadingState()
        else if (viewModel.error != null)
          _buildErrorState(context, viewModel.error!)
        else if (viewModel.jobs.isEmpty)
          _buildEmptyState()
        else
          _buildJobGrid(viewModel, isDesktop),
      ],
    );
  }

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
                          backgroundColor: const Color(0xFF0D9488),
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
    required MasterModel? selected,
    required List<MasterModel> items,
    required Function(MasterModel?) onChanged,
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
          child: DropdownButton<MasterModel>(
            value: selected,
            hint: Text('Select $label'),
            items: [
              DropdownMenuItem<MasterModel>(
                value: null,
                child: Text('All $label'),
              ),
              ...items.map((item) {
                return DropdownMenuItem<MasterModel>(
                  value: item,
                  child: Text(item.name.toString()),
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
  // JOB GRID — two cards per row on desktop, single column
  // (stacked) on mobile, matching the reference layouts.
  // =========================================================
  Widget _buildJobGrid(JobDashboardViewModel viewModel, bool isDesktop) {
    final jobs = viewModel.jobs;

    if (!isDesktop) {
      return Column(
        children: List.generate(jobs.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i == jobs.length - 1 ? 0 : 20),
            child: _buildJobCard(jobs[i], i, isDesktop: false),
          );
        }),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < jobs.length; i += 2) {
      final hasSecond = i + 1 < jobs.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 >= jobs.length ? 0 : 20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildJobCard(jobs[i], i, isDesktop: true)),
                const SizedBox(width: 20),
                Expanded(
                  child: hasSecond
                      ? _buildJobCard(jobs[i + 1], i + 1, isDesktop: true)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildJobCard(JobsModel job, int index, {required bool isDesktop}) {
    final accent = _accentGradients[index % _accentGradients.length];
    final isBookmarked = _bookmarked.contains(index);
    final industryLabel = (job.industryName ?? 'Technology').toUpperCase();
    final locationLabel = (job.location ?? 'Location').toUpperCase();

    final headerRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent[0].withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_iconForIndustry(job.industryName), color: accent[1]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$industryLabel · $locationLabel',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                job.jobRoleName ?? 'Job Title',
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (isBookmarked) {
                _bookmarked.remove(index);
              } else {
                _bookmarked.add(index);
              }
            });
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              size: 16,
              color: isBookmarked ? accent[1] : Colors.grey[500],
            ),
          ),
        ),
      ],
    );

    final infoRow = Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildInfoItem('Salary', job.salaryRange ?? '₹9–13 LPA'),
          _buildDivider(),
          _buildInfoItem('Experience', job.experienceRequired ?? '3–5 years'),
          _buildDivider(),
          _buildInfoItem('Age limit', job.ageLimit ?? '21–35 years'),
        ],
      ),
    );

    final qualificationBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('MINIMUM QUALIFICATION'),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.school_outlined, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                job.qualificationName ??
                    'B.E./B.Tech in Computer Science or related field',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ),
      ],
    );

    final employmentBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('EMPLOYMENT DETAILS'),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              job.workMode == 'Remote' || job.workMode == 'Hybrid'
                  ? Icons.laptop_mac_outlined
                  : Icons.business_center_outlined,
              size: 16,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              job.workMode ?? 'Hybrid · 3 office days',
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
            const SizedBox(width: 6),
            Text(
              job.workShiftTiming ?? '10:00 AM–7:00 PM, Mon–Fri',
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ],
    );

    final languagesBlock = (job.languages != null && job.languages!.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('LANGUAGES KNOWN'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.languages!
                    .map((lang) => _buildPill(lang))
                    .toList(),
              ),
            ],
          )
        : const SizedBox.shrink();

    final skillsBlock = (job.skills != null && job.skills!.isNotEmpty)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('SKILLS REQUIRED'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.skills!
                    .map((skill) => _buildPill(skill))
                    .toList(),
              ),
            ],
          )
        : const SizedBox.shrink();

    final descriptionBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('JOB DESCRIPTION'),
        const SizedBox(height: 6),
        Text(
          job.jobDescription ??
              'Build responsive customer workflows for a B2B analytics platform. Partner with product and design to ship accessible, performant features used by operations teams every day.',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );

    final benefitsBlock = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3E2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BENEFITS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.orange[800],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            job.jobBenefits ??
                'Medical cover, ₹30,000 learning budget, flexible leave, and home-office allowance.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.brown[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );

    final applyButton = SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: () => _showJobDetails(context, job),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF97316),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Apply now',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );

    final body = isDesktop
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerRow,
              const SizedBox(height: 16),
              infoRow,
              const SizedBox(height: 18),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          qualificationBlock,
                          const SizedBox(height: 12),
                          languagesBlock,
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          employmentBlock,
                          const SizedBox(height: 12),
                          skillsBlock,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              benefitsBlock,
              const SizedBox(height: 18),
              descriptionBlock,
              const SizedBox(height: 20),
              applyButton,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerRow,
              const SizedBox(height: 16),
              infoRow,
              const SizedBox(height: 16),
              qualificationBlock,
              const SizedBox(height: 14),
              employmentBlock,
              const SizedBox(height: 14),
              languagesBlock,
              if (job.languages != null && job.languages!.isNotEmpty)
                const SizedBox(height: 14),
              skillsBlock,
              if (job.skills != null && job.skills!.isNotEmpty)
                const SizedBox(height: 14),
              descriptionBlock,
              const SizedBox(height: 14),
              benefitsBlock,
              const SizedBox(height: 18),
              applyButton,
            ],
          );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(gradient: LinearGradient(colors: accent)),
          ),
          Padding(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: InkWell(
              onTap: () => _showJobDetails(context, job),
              child: body,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForIndustry(String? industry) {
    final value = (industry ?? '').toLowerCase();
    if (value.contains('tech')) return Icons.code;
    if (value.contains('retail') || value.contains('business')) {
      return Icons.show_chart;
    }
    if (value.contains('finance')) return Icons.account_balance_outlined;
    if (value.contains('health')) return Icons.health_and_safety_outlined;
    return Icons.work_outline;
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.grey[300]);
  }

  // =========================================================
  // LOADING / ERROR / EMPTY STATES
  // =========================================================
  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF0D9488)),
            SizedBox(height: 16),
            Text('Loading jobs...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
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
      ),
    );
  }

  void _showJobDetails(BuildContext context, JobsModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetails(job: job)),
    );
  }
}
