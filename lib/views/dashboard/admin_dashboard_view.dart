import 'package:flutter/material.dart';
import 'package:gurukulam/viewModels/job_viewmodel.dart';
import 'package:gurukulam/views/jobcreation.dart';
import 'package:gurukulam/views/master/master_page.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  static const Color primaryColor = Color(0xFF0D9488);
  static const Color blueColor = Color(0xFF3869EB);
  static const Color yellowColor = Color(0xFFF4C20D);
  static const Color backgroundColor = Color(0xFFF5F7FF);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardView.backgroundColor,
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
      color: DashboardView.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo / App name
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

          // Search
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

          // Notification
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
              color: DashboardView.blueColor,
            ),
          ),

          const SizedBox(width: 16),

          // Profile
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
                    color: DashboardView.blueColor,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: DashboardView.yellowColor,
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
                color: DashboardView.yellowColor,
              ),
            ),
          ),

          const SizedBox(height: 20),

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
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => JobViewModel(),
                    child: const JobCreationPage(),
                  ),
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

          // Masters
          _menuItem(
            icon: Icons.settings_outlined,
            title: 'Masters',
            selected: false,
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

          const SizedBox(height: 8),

          _menuItem(
            icon: Icons.business_outlined,
            title: 'Industry',
            selected: false,
            onTap: () {},
          ),

          const SizedBox(height: 8),

          _menuItem(
            icon: Icons.school_outlined,
            title: 'Education',
            selected: false,
            onTap: () {},
          ),
        ],
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
                    ? DashboardView.blueColor
                    : DashboardView.yellowColor,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? DashboardView.blueColor
                      : DashboardView.yellowColor,
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
              // Heading
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

              // First row
              _buildStatisticsGrid(),

              const SizedBox(height: 28),

              // Second row
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
              iconColor: DashboardView.blueColor,
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
                iconColor: DashboardView.blueColor,
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
                iconColor: DashboardView.blueColor,
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
