import 'package:flutter/material.dart';
import 'package:gurukulam/viewModels/job_viewmodel.dart';
import 'package:gurukulam/views/jobcreation.dart';
import 'package:gurukulam/views/master/master_page.dart';
import 'package:provider/provider.dart';

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
                  Expanded(child: _buildDashboardContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
  // FIXED SIDEBAR - WITH SCROLL
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
          // ===== SCROLLABLE SIDEBAR =====
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard
                  _menuItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    selected: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),

          // Job Creation
          _menuItem(
            icon: Icons.work_outline,
            title: 'Job Creation',
            selected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobCreationPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

                  // Applicants
                  _menuItem(
                    icon: Icons.people_outline,
                    title: 'Applicants',
                    selected: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),

                  // ===== MASTERS WITH DROPDOWN =====
                  _buildMasterMenuItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== MASTER MENU WITH DROPDOWN - ALL CORRECT TABLE NAMES =====
  Widget _buildMasterMenuItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.settings_outlined,
            size: 18,
            color: DashboardView.yellowColor,
          ),
          title: const Text(
            'Masters',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: DashboardView.yellowColor,
            ),
          ),
          iconColor: DashboardView.yellowColor,
          collapsedIconColor: DashboardView.yellowColor,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: const EdgeInsets.only(left: 30),
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
          ),
          children: [
            // Language
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.translate,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Language',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MasterPage(tableName: 'language', title: 'Language'),
                  ),
                );
              },
            ),
            // Industry
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.business_outlined,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Industry',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MasterPage(tableName: 'industry', title: 'Industry'),
                  ),
                );
              },
            ),
            // Degree
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.school_outlined,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Degree',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MasterPage(tableName: 'degree', title: 'Degree'),
                  ),
                );
              },
            ),
            // Education Level
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.auto_stories_outlined,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Education Level',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MasterPage(
                      tableName: 'education_level',
                      title: 'Education Level',
                    ),
                  ),
                );
              },
            ),
            // Employment
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.work_history_outlined,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Employment',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MasterPage(
                          tableName: 'employment_type',
                          title: 'Employment',
                        ),
                  ),
                );
              },
            ),
            // Job Role
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.assignment_outlined,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Job Role',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MasterPage(tableName: 'job_role', title: 'Job Role'),
                  ),
                );
              },
            ),
            // Major Specification
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.science_outlined,
                size: 16,
                color: DashboardView.yellowColor,
              ),
              title: const Text(
                'Major Specification',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: DashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MasterPage(
                      tableName: 'major_specialization',
                      title: 'Major Specification',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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

  // =========================================================
  Widget _buildDashboardContent() {
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

  // =========================================================
  Widget _buildStatisticsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 3;
        if (width < 900) {
          columns = 2;
        }
        if (width < 600) {
          columns = 1;
        }
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.32,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _statCard(
              title: 'Jobs Open',
              value: '4',
              footer: '+2 this week',
              icon: Icons.work_outline,
              iconBackground: const Color(0xFFEEF2FF),
              iconColor: AdminDashboardView.blueColor,
            ),
            _statCard(
              title: 'Jobs Hold',
              value: '3',
              footer: '+1 this week',
              icon: Icons.pause_circle_outline,
              iconBackground: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFF59E0B),
            ),
            _statCard(
              title: 'Jobs Placed',
              value: '3',
              footer: '+1 this week',
              icon: Icons.check_circle_outline,
              iconBackground: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF10B981),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF999999),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF313131),
              height: 1,
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
                style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
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