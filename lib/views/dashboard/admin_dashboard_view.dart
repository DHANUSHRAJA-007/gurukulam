import 'package:flutter/material.dart';
import 'package:gurukulam/views/jobcreation.dart';
import 'package:gurukulam/views/master/master_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_view.dart';

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

  final List<Widget> _pages = [
    const _DashboardContent(),
    const JobCreationPage(),
    const _ApplicantsContent(),
  ];

  final List<String> _pageTitles = ['Dashboard', 'Job Creation', 'Applicants'];

  final List<IconData> _navIcons = [
    Icons.dashboard_outlined,
    Icons.work_outline,
    Icons.people_outline,
  ];

  final List<IconData> _navIconsActive = [
    Icons.dashboard,
    Icons.work,
    Icons.people,
  ];

  final List<MasterItem> _masterItems = const [
    MasterItem(icon: Icons.translate, title: 'Language', tableName: 'language'),
    MasterItem(icon: Icons.business_outlined, title: 'Industry', tableName: 'industry'),
    MasterItem(icon: Icons.school_outlined, title: 'Degree', tableName: 'degree'),
    MasterItem(icon: Icons.auto_stories_outlined, title: 'Education Level', tableName: 'education_level'),
    MasterItem(icon: Icons.work_history_outlined, title: 'Employment', tableName: 'employment_type'),
    MasterItem(icon: Icons.assignment_outlined, title: 'Job Role', tableName: 'job_role'),
    MasterItem(icon: Icons.science_outlined, title: 'Major Specification', tableName: 'major_specialization'),
    MasterItem(icon: Icons.location_on_outlined, title: 'Location', tableName: 'location'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminDashboardView.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
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
      backgroundColor: AdminDashboardView.backgroundColor,
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
          Text(
            _pageTitles[_selectedIndex],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
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
                prefixIcon: Icon(Icons.search, size: 16, color: Color(0xFF999999)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
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
                  child: Icon(Icons.person, size: 17, color: AdminDashboardView.blueColor),
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
  // TOP BAR (Mobile)
  // =========================================================
  Widget _buildMobileTopBar() {
    return Container(
      height: 60,
      color: AdminDashboardView.primaryColor,
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
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 22,
            ),
            onPressed: _showMasterBottomSheet,
          ),
          const SizedBox(width: 8),
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
                _showAdminInfoDialog(context);
              },
            ),
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
        selectedItemColor: AdminDashboardView.primaryColor,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? _navIconsActive[0] : _navIcons[0]),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? _navIconsActive[1] : _navIcons[1]),
            label: 'Job Creation',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? _navIconsActive[2] : _navIcons[2]),
            label: 'Applicants',
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
        boxShadow: [BoxShadow(color: Color(0x08000000), offset: Offset(2, 0), blurRadius: 8)],
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
                  _menuItem(
                    icon: Icons.work_outline,
                    iconActive: Icons.work,
                    title: 'Job Creation',
                    index: 1,
                    selected: _selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _menuItem(
                    icon: Icons.people_outline,
                    iconActive: Icons.people,
                    title: 'Applicants',
                    index: 2,
                    selected: _selectedIndex == 2,
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildMasterMenuItem(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _menuItem(
              icon: Icons.logout_outlined,
              iconActive: Icons.logout,
              title: 'Logout',
              index: -1,
              selected: false,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MASTER BOTTOM SHEET (Mobile)
  // =========================================================
  void _showMasterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Masters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select a master to manage',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _masterItems.map((item) {
                    return ListTile(
                      leading: Icon(item.icon, color: AdminDashboardView.primaryColor),
                      title: Text(item.title),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MasterPage(
                              tableName: item.tableName,
                              title: item.title,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // MASTER MENU ITEM (Desktop)
  // =========================================================
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
          children: _masterItems.map((item) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: Icon(
                item.icon,
                size: 16,
                color: AdminDashboardView.yellowColor,
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AdminDashboardView.yellowColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MasterPage(
                      tableName: item.tableName,
                      title: item.title,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
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
                    ? AdminDashboardView.blueColor
                    : AdminDashboardView.yellowColor,
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
  // LOGOUT DIALOG
  // =========================================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          TextButton(
            onPressed: () async {
               Navigator.pop(context);

              try {
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                 Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                      (Route<dynamic> route) => false,
                );
              } catch (e) {
                print('Logout error: $e');
                // If error, still try to navigate to login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                      (Route<dynamic> route) => false,
                );
              }
            },
            child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  void _showAdminInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👤 Admin User'),
            SizedBox(height: 8),
            Text('📧 admin@gurukulam.com'),
            SizedBox(height: 8),
            Text('🔑 Admin Panel Access'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
            child: Text('Logout', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// MASTER ITEM MODEL
// =========================================================
class MasterItem {
  final IconData icon;
  final String title;
  final String tableName;

  const MasterItem({
    required this.icon,
    required this.title,
    required this.tableName,
  });
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF313131)),
              ),
              const SizedBox(height: 4),
              const Text(
                "Welcome back! Here's what's happening with your applicants today.",
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 32),
              _buildStatisticsGrid(constraints),
              const SizedBox(height: 28),
              _buildSecondRow(constraints),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsGrid(BoxConstraints constraints) {
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
          BoxShadow(color: Color(0x14000000), offset: Offset(3, 5), blurRadius: 20),
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
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF999999)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF313131)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          footer,
                          style: const TextStyle(fontSize: 9, color: Color(0xFF999999)),
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
            decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondRow(BoxConstraints constraints) {
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
          BoxShadow(color: Color(0x14000000), offset: Offset(3, 5), blurRadius: 20),
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
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF999999)),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF313131)),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
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
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(12)),
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