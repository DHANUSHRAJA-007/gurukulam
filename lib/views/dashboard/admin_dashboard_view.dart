import 'package:flutter/material.dart';
import 'package:gurukulam/views/jobcreation.dart';
import 'package:gurukulam/views/master/master_page.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  static const Color primaryColor = Color(0xFF0D9488);
  static const Color blueColor = Color(0xFF3869EB);
  static const Color yellowColor = Color(0xFFF4C20D);
  static const Color backgroundColor = Color(0xFFF5F7FF);

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _selectedIndex = 0;
  String? _selectedMaster;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminDashboardView.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  Expanded(child: _buildMainContent()), // ← Fixed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TOP BAR
  // =========================================================
  Widget _buildTopBar() {
    return Container(
      height: 69,
      color: AdminDashboardView.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'GURUKULAM',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            width: 180,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 12),
                prefixIcon: Icon(
                  Icons.search,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 18,
              color: AdminDashboardView.blueColor,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFEEF2FF),
                  child: Icon(
                    Icons.person,
                    size: 17,
                    color: AdminDashboardView.blueColor,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AdminDashboardView.yellowColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MAIN CONTENT - FIXED ✅
  // =========================================================
  Widget _buildMainContent() {
    if (_selectedMaster != null) {
      return MasterPage(
        tableName: _selectedMaster!,
        title: _getMasterTitle(_selectedMaster!),
      );
    }

    // Use switch for better performance
    switch (_selectedIndex) {
      case 0:
        return const _DashboardContent();
      case 1:
        return const JobCreationPage();
      case 2:
        return const _ApplicantsContent();
      default:
        return const _DashboardContent();
    }
  }

  String _getMasterTitle(String tableName) {
    final titles = {
      'language': 'Language',
      'industry': 'Industry',
      'degree': 'Degree',
      'education_level': 'Education Level',
      'employment_type': 'Employment',
      'job_role': 'Job Role',
      'major_specialization': 'Major Specification',
      'location': 'Location',
    };
    return titles[tableName] ?? tableName;
  }

  // =========================================================
  // SIDEBAR
  // =========================================================
  Widget _buildSidebar() {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Color(0xFF0D9488),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(2, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'MAIN MENU',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: AdminDashboardView.yellowColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    selected: _selectedIndex == 0 && _selectedMaster == null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        _selectedMaster = null;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _menuItem(
                    icon: Icons.work_outline,
                    title: 'Job Creation',
                    selected: _selectedIndex == 1 && _selectedMaster == null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                        _selectedMaster = null;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _menuItem(
                    icon: Icons.people_outline,
                    title: 'Applicants',
                    selected: _selectedIndex == 2 && _selectedMaster == null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                        _selectedMaster = null;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildMasterMenuItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== MASTER MENU WITH DROPDOWN =====
  Widget _buildMasterMenuItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.settings_outlined,
            size: 18,
            color: AdminDashboardView.yellowColor,
          ),
          title: const Text(
            'Masters',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AdminDashboardView.yellowColor,
            ),
          ),
          iconColor: AdminDashboardView.yellowColor,
          collapsedIconColor: AdminDashboardView.yellowColor,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: const EdgeInsets.only(left: 30),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
          ),
          children: [
            _masterListItem(
              icon: Icons.translate,
              title: 'Language',
              tableName: 'language',
            ),
            _masterListItem(
              icon: Icons.business_outlined,
              title: 'Industry',
              tableName: 'industry',
            ),
            _masterListItem(
              icon: Icons.school_outlined,
              title: 'Degree',
              tableName: 'degree',
            ),
            _masterListItem(
              icon: Icons.auto_stories_outlined,
              title: 'Education Level',
              tableName: 'education_level',
            ),
            _masterListItem(
              icon: Icons.work_history_outlined,
              title: 'Employment',
              tableName: 'employment_type',
            ),
            _masterListItem(
              icon: Icons.assignment_outlined,
              title: 'Job Role',
              tableName: 'job_role',
            ),
            _masterListItem(
              icon: Icons.science_outlined,
              title: 'Major Specification',
              tableName: 'major_specialization',
            ),
            _masterListItem(
              icon: Icons.location_on_outlined,
              title: 'Location',
              tableName: 'location',
            ),
          ],
        ),
      ),
    );
  }

  // ===== MASTER LIST ITEM =====
  Widget _masterListItem({
    required IconData icon,
    required String title,
    required String tableName,
  }) {
    final isSelected = _selectedMaster == tableName;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Icon(
        icon,
        size: 16,
        color: isSelected
            ? AdminDashboardView.blueColor
            : AdminDashboardView.yellowColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected
              ? AdminDashboardView.blueColor
              : AdminDashboardView.yellowColor,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedMaster = tableName;
        });
      },
    );
  }

  // ===== MENU ITEM =====
  Widget _menuItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEEF2FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? AdminDashboardView.blueColor
                    : AdminDashboardView.yellowColor,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? AdminDashboardView.blueColor
                      : AdminDashboardView.yellowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// DASHBOARD CONTENT
// =========================================================
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 42, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF313131),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Welcome back! Here's what's happening "
                    "with your applicants today.",
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 32),
              _buildStatisticsGrid(),
              const SizedBox(height: 28),
              _buildSecondRow(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 3;
        if (width < 900) columns = 2;
        if (width < 600) columns = 1;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            SizedBox(
              width: (width - (columns - 1) * 20) / columns,
              child: _statCard(
                title: 'Jobs Open',
                value: '4',
                footer: '+2 this week',
                icon: Icons.work_outline,
                iconBackground: const Color(0xFFEEF2FF),
                iconColor: AdminDashboardView.blueColor,
              ),
            ),
            SizedBox(
              width: (width - (columns - 1) * 20) / columns,
              child: _statCard(
                title: 'Jobs Hold',
                value: '3',
                footer: '+1 this week',
                icon: Icons.pause_circle_outline,
                iconBackground: const Color(0xFFFFFBEB),
                iconColor: const Color(0xFFF59E0B),
              ),
            ),
            SizedBox(
              width: (width - (columns - 1) * 20) / columns,
              child: _statCard(
                title: 'Jobs Placed',
                value: '3',
                footer: '+1 this week',
                icon: Icons.check_circle_outline,
                iconBackground: const Color(0xFFECFDF5),
                iconColor: const Color(0xFF10B981),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String footer,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(3, 5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRect(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF313131),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          footer,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF999999),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < 700) {
          return Column(
            children: [
              _secondCard(
                title: 'Total Applicants',
                value: '15',
                footer: 'All applicants',
                icon: Icons.people_outline,
                iconColor: AdminDashboardView.blueColor,
                iconBackground: const Color(0xFFEEF2FF),
              ),
              const SizedBox(height: 20),
              _secondCard(
                title: 'Unfilled Profiles',
                value: '3',
                footer: 'Needs attention',
                icon: Icons.person_outline,
                iconColor: const Color(0xFFEF4444),
                iconBackground: const Color(0xFFFEF2F2),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _secondCard(
                title: 'Total Applicants',
                value: '15',
                footer: 'All applicants',
                icon: Icons.people_outline,
                iconColor: AdminDashboardView.blueColor,
                iconBackground: const Color(0xFFEEF2FF),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _secondCard(
                title: 'Unfilled Profiles',
                value: '3',
                footer: 'Needs attention',
                icon: Icons.person_outline,
                iconColor: const Color(0xFFEF4444),
                iconBackground: const Color(0xFFFEF2F2),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _secondCard({
    required String title,
    required String value,
    required String footer,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      height: 134,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(3, 5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF313131),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      footer,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// APPLICANTS CONTENT
// =========================================================
class _ApplicantsContent extends StatelessWidget {
  const _ApplicantsContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Applicants Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}