import 'package:flutter/material.dart';
import 'package:gurukulam/views/jobcreation.dart';
import 'package:gurukulam/views/master/master_page.dart';

import '../profile/profile_page.dart';
import 'job_dashboard.dart';

class UserDashboardView extends StatefulWidget {
  const UserDashboardView({super.key});

  static const Color primaryColor = Color(0xFF0D9488);
  static const Color blueColor = Color(0xFF3869EB);
  static const Color yellowColor = Color(0xFFF4C20D);
  static const Color backgroundColor = Color(0xFFF5F7FF);

  @override
  State<UserDashboardView> createState() => _UserDashboardViewState();
}

class _UserDashboardViewState extends State<UserDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserDashboardView.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  Expanded(child: JobDashboard()),
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
      color: UserDashboardView.primaryColor,
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
                color: UserDashboardView.yellowColor,
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
            icon: Icons.work_history_outlined,
            title: 'Applied Jobs',
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
            icon: Icons.person_2_outlined,
            title: 'My Profile',
            selected: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            },
          ),

          const SizedBox(height: 8),

          // Masters
          _menuItem(
            icon: Icons.logout_outlined,
            title: 'Logout',
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
                    ? UserDashboardView.blueColor
                    : UserDashboardView.yellowColor,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? UserDashboardView.blueColor
                      : UserDashboardView.yellowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
