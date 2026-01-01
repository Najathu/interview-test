import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/task_model.dart';
import '../../core/theme/app_theme.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.errorColor, Color(0xFFE74C3C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
      ),
      onDismissed: (direction) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: task.isCompleted
              ? AppTheme.successGradient
              : (isDark
                    ? LinearGradient(
                        colors: [
                          AppTheme.darkCard,
                          AppTheme.darkCard.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          AppTheme.lightCard,
                          AppTheme.lightCard.withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: task.isCompleted
                  ? AppTheme.successColor.withOpacity(0.3)
                  : (isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1)),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Checkbox with animation
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: task.isCompleted
                            ? AppTheme.successGradient
                            : null,
                        border: task.isCompleted
                            ? null
                            : Border.all(
                                color: isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.lightTextSecondary,
                                width: 2,
                              ),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Task content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? Colors.white
                                    : (isDark
                                          ? AppTheme.darkTextPrimary
                                          : AppTheme.lightTextPrimary),
                              ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            task.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? Colors.white.withOpacity(0.8)
                                      : (isDark
                                            ? AppTheme.darkTextSecondary
                                            : AppTheme.lightTextSecondary),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
