import 'package:flutter/material.dart';
import 'package:gurukulam/views/jobcreation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login_view.dart';
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
  int _selectedIndex = 0; // 0: Dashboard, 1: Applied Jobs, 2: Profile

  final List<Widget> _pages = [
    const JobDashboard(),
    const JobCreationPage(),
    const ProfilePage(),
  ];

  final List<String> _pageTitles = ['Dashboard', 'Applied Jobs', 'My Profile'];

  final List<IconData> _navIcons = [
    Icons.dashboard_outlined,
    Icons.work_history_outlined,
    Icons.person_2_outlined,
  ];

  final List<IconData> _navIconsActive = [
    Icons.dashboard,
    Icons.work_history,
    Icons.person_2,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserDashboardView.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check if it's mobile (width < 600) or desktop
            final isMobile = constraints.maxWidth < 600;

            return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
          },
        ),
      ),
    );
  }

  // =========================================================
  // DESKTOP LAYOUT
  // =========================================================
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: Row(
            children: [
              _buildSidebar(),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // MOBILE LAYOUT
  // =========================================================
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: UserDashboardView.backgroundColor,
      body: Column(
        children: [
          _buildMobileTopBar(),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // =========================================================
  // TOP BAR (Desktop)
  // =========================================================
  Widget _buildTopBar() {
    return Container(
      height: 69,
      color: UserDashboardView.primaryColor,
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
          // Desktop: Show current page title
          Text(
            _pageTitles[_selectedIndex],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TOP BAR (Mobile)
  // =========================================================
  Widget _buildMobileTopBar() {
    return Container(
      height: 60,
      color: UserDashboardView.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'GURUKULAM',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          // Mobile: Profile avatar or notification
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SIDEBAR (Desktop)
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
            iconActive: Icons.dashboard,
            title: 'Dashboard',
            index: 0,
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),

          const SizedBox(height: 8),

          // Applied Jobs
          _menuItem(
            icon: Icons.work_history_outlined,
            iconActive: Icons.work_history,
            title: 'Applied Jobs',
            index: 1,
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),

          const SizedBox(height: 8),

          // Profile
          _menuItem(
            icon: Icons.person_2_outlined,
            iconActive: Icons.person_2,
            title: 'My Profile',
            index: 2,
            selected: _selectedIndex == 2,
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),

          const SizedBox(height: 8),

          // Logout
          _menuItem(
            icon: Icons.logout_outlined,
            iconActive: Icons.logout,
            title: 'Logout',
            index: -1,
            selected: false,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION BAR (Mobile)
  // =========================================================
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: UserDashboardView.primaryColor,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? _navIconsActive[0] : _navIcons[0]),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? _navIconsActive[1] : _navIcons[1]),
            label: 'Applied Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? _navIconsActive[2] : _navIcons[2]),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MENU ITEM
  // =========================================================
  Widget _menuItem({
    required IconData icon,
    required IconData iconActive,
    required String title,
    required int index,
    required bool selected,
    required VoidCallback onTap,
  }) {
    // For logout, use different styling
    final isLogout = index == -1;

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
                selected ? iconActive : icon,
                size: 18,
                color: isLogout
                    ? Colors.red.shade300
                    : selected
                    ? UserDashboardView.blueColor
                    : UserDashboardView.yellowColor,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: isLogout
                      ? Colors.red.shade300
                      : selected
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

  // =========================================================
  // LOGOUT DIALOG
  // =========================================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }
}
