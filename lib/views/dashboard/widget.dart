import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../viewModels/job_dashboard_viewmodel.dart';

Widget buildGreetingHeader(bool isDesktop, JobDashboardViewModel viewModel) {
  final now = DateTime.now();
  final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);
  final timeOfDay = _getTimeOfDay();

  final avatar = Container(
    width: isDesktop ? 56 : 50,
    height: isDesktop ? 56 : 50,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        viewModel.username.substring(0, 2).toUpperCase(),
        style: TextStyle(
          color: const Color(0xFFF5A524),
          fontWeight: FontWeight.bold,
          fontSize: isDesktop ? 20 : 18,
        ),
      ),
    ),
  );

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(isDesktop ? 28 : 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: isDesktop ? Alignment.centerLeft : Alignment.topLeft,
        end: isDesktop ? Alignment.centerRight : Alignment.bottomRight,
        colors: isDesktop
            ? const [Color(0xFF0D9488), Color(0xFF2563EB), Color(0xFF7C3AED)]
            : const [Color(0xFF6D28D9), Color(0xFF2563EB), Color(0xFF0D9488)],
      ),
    ),
    child: isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatar,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Good $timeOfDay, ${viewModel.username}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('👋', style: TextStyle(fontSize: 26)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Welcome back! Here's what's happening with your job search today.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  avatar,
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Good $timeOfDay!',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('👋', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Text(
                          viewModel.username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stack(
                  //   clipBehavior: Clip.none,
                  //   children: [
                  //     Container(
                  //       width: 38,
                  //       height: 38,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white.withOpacity(0.18),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Icon(
                  //         Icons.notifications_none,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 2,
                  //       right: 2,
                  //       child: Container(
                  //         width: 8,
                  //         height: 8,
                  //         decoration: const BoxDecoration(
                  //           color: Color(0xFFF59E0B),
                  //           shape: BoxShape.circle,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Here's what's happening with your job search today.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
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

Widget buildLabeledField({
  required String label,
  required bool required,
  required TextEditingController controller,
  required String hint,
  required ValueChanged<String> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          children: required
              ? const [
                  TextSpan(
                    text: '  *',
                    style: TextStyle(color: Color(0xFFEF4444)),
                  ),
                ]
              : null,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF99F0DC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
          ),
        ),
      ),
    ],
  );
}

// A tiny 4-dot "logo mark" painter used for the mobile top bar,
// standing in for the colorful brand icon in the reference design.
class LogoDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 4.4;
    final colors = [
      const Color(0xFFF97316),
      const Color(0xFF10B981),
      const Color(0xFF6366F1),
      const Color(0xFFF59E0B),
    ];
    final centers = [
      Offset(size.width * 0.32, size.height * 0.32),
      Offset(size.width * 0.68, size.height * 0.32),
      Offset(size.width * 0.32, size.height * 0.68),
      Offset(size.width * 0.68, size.height * 0.68),
    ];
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(centers[i], r, Paint()..color = colors[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
