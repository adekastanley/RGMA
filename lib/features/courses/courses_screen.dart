import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/course.dart';
import '../../state/learning_controller.dart';
import '../../widgets/rhema_ui_widgets.dart';

class CoursesScreen extends StatefulWidget {
  final LearningController controller;
  final ValueChanged<Course> onOpenClassroom;

  const CoursesScreen({
    super.key,
    required this.controller,
    required this.onOpenClassroom,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _searchQuery = '';
  String _filter = 'All';

  static const List<String> _filters = ['All', 'Ongoing', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final allCourses = widget.controller.courses;
    final filtered = allCourses.where((course) {
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Ongoing' && course.isOngoing) ||
          (_filter == 'Completed' && !course.isOngoing);
      final matchesQuery = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.code.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Courses',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Level 1 Curriculum • 2026–2027 Session',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.rhemaNavy,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${allCourses.length} Modules',
                    style: const TextStyle(
                      color: AppColors.rhemaGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Search Input
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search courses by title or code (e.g. RBT-104)...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.rhemaNavy),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Pills
            Row(
              children: _filters.map((filterName) {
                final isSelected = _filter == filterName;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = filterName),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.rhemaGold
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.rhemaGold
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        filterName,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.rhemaNavy
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Course List Cards
            ...filtered.map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _FullCourseCard(
                  course: course,
                  onTap: () => widget.onOpenClassroom(course),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const _FullCourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.rhemaNavy,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${course.code} • ${course.level}',
                  style: const TextStyle(
                    color: AppColors.rhemaGold,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${course.totalSessions} Sessions • ${course.totalDuration}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            course.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            course.subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: course.progressPercent,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.rhemaGold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${course.completedSessionsCount}/${course.totalSessions} Completed',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.rhemaNavy,
                  border: Border.all(color: AppColors.rhemaGold, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  course.instructor.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  course.instructor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              NeonPillButton(
                label: course.isOngoing ? 'Enter Class' : 'Review',
                isCompact: true,
                onTap: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
