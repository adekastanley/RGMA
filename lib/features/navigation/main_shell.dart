import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/course.dart';
import '../../state/learning_controller.dart';
import '../classroom/classroom_screen.dart';
import '../courses/courses_screen.dart';
import '../downloads/downloads_screen.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final LearningController controller;

  const MainShell({
    super.key,
    required this.controller,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _showOnboarding = true;
  int _currentTabIndex = 0;

  void _openClassroomForCourse(Course course, {int? sessionNumber}) {
    widget.controller.selectCourse(course.id, sessionNumber: sessionNumber);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClassroomScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(
        onGetStarted: () => setState(() => _showOnboarding = false),
      );
    }

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final pages = [
          HomeScreen(
            controller: widget.controller,
            onOpenClassroom: (course) => _openClassroomForCourse(course),
            onNavigateToCourses: () => setState(() => _currentTabIndex = 1),
            onNavigateToProfile: () => setState(() => _currentTabIndex = 3),
          ),
          CoursesScreen(
            controller: widget.controller,
            onOpenClassroom: (course) => _openClassroomForCourse(course),
          ),
          DownloadsScreen(
            controller: widget.controller,
            onPlayDownloadedSession: (courseId, sessionNumber) {
              final course = widget.controller.courses.firstWhere(
                (c) => c.id == courseId,
                orElse: () => widget.controller.activeCourse,
              );
              _openClassroomForCourse(course, sessionNumber: sessionNumber);
            },
          ),
          ProfileScreen(
            controller: widget.controller,
            onReturnToOnboarding: () => setState(() => _showOnboarding = true),
          ),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              IndexedStack(
                index: _currentTabIndex,
                children: pages,
              ),

              // Floating Deep Navy Bottom Navigation Dock (with Rhema Gold active tab)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.controller.isPlaying)
                      _MiniNowPlayingBar(
                        controller: widget.controller,
                        onTap: () => _openClassroomForCourse(
                          widget.controller.activeCourse,
                          sessionNumber:
                              widget.controller.activeSession.sessionNumber,
                        ),
                      ),
                    const SizedBox(height: 8),
                    _FloatingBottomNavBar(
                      currentIndex: _currentTabIndex,
                      downloadsCount:
                          widget.controller.downloadedSessions.length,
                      onSelectTab: (index) =>
                          setState(() => _currentTabIndex = index),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final int downloadsCount;
  final ValueChanged<int> onSelectTab;

  const _FloatingBottomNavBar({
    required this.currentIndex,
    required this.downloadsCount,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.rhemaNavy,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppColors.rhemaNavyBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.rhemaNavy.withValues(alpha: 0.32),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavTabItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onSelectTab(0),
          ),
          _NavTabItem(
            icon: Icons.menu_book_rounded,
            label: 'Course',
            isSelected: currentIndex == 1,
            onTap: () => onSelectTab(1),
          ),
          _NavTabItem(
            icon: Icons.download_for_offline_outlined,
            label: 'Downloads',
            badgeCount: downloadsCount,
            isSelected: currentIndex == 2,
            onTap: () => onSelectTab(2),
          ),
          _NavTabItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isSelected: currentIndex == 3,
            onTap: () => onSelectTab(3),
          ),
        ],
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.rhemaGold : AppColors.textOnNavyMuted;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.rhemaGold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: AppColors.rhemaNavy,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniNowPlayingBar extends StatelessWidget {
  final LearningController controller;
  final VoidCallback onTap;

  const _MiniNowPlayingBar({
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final course = controller.activeCourse;
    final session = controller.activeSession;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.rhemaNavyElevated,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.rhemaGold.withValues(alpha: 0.65),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.rhemaGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.graphic_eq_rounded,
                color: AppColors.rhemaNavy,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Playing: ${course.title} • Session ${session.sessionNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textOnNavy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textOnNavyMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: controller.togglePlayPause,
              icon: const Icon(
                Icons.pause_circle_filled_rounded,
                color: AppColors.rhemaGold,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
