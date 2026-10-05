import 'package:flutter/material.dart';
import '../models/mood_type.dart';

/// An interactive, beautifully styled mood card widget.
///
/// Features custom [AnimationController] scale & fade tap feedback, subtle accent tints,
/// elevated borders, glowing shadows, and clear selection indicators.
class MoodChip extends StatefulWidget {
  final MoodType mood;
  final bool isSelected;
  final ValueChanged<MoodType> onSelect;

  const MoodChip({
    super.key,
    required this.mood,
    this.isSelected = false,
    required this.onSelect,
  });

  @override
  State<MoodChip> createState() => _MoodChipState();
}

class _MoodChipState extends State<MoodChip> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isProcessingTap = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.50), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.50, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (_isProcessingTap) return;
    setState(() {
      _isProcessingTap = true;
    });

    await _animController.forward(from: 0.0);

    if (mounted) {
      widget.onSelect(widget.mood);
      setState(() {
        _isProcessingTap = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color activeMoodColor = widget.mood.color;
    final bool isHighlight = widget.isSelected;

    return Semantics(
      label: 'Mood: ${widget.mood.label}',
      button: true,
      selected: isHighlight,
      child: GestureDetector(
        onTap: _handleTap,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: isHighlight
                    ? activeMoodColor.withValues(alpha: isDark ? 0.22 : 0.10)
                    : theme.cardTheme.color,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isHighlight
                      ? activeMoodColor
                      : colorScheme.outline.withValues(alpha: isDark ? 0.4 : 0.6),
                  width: isHighlight ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHighlight
                        ? activeMoodColor.withValues(alpha: isDark ? 0.35 : 0.20)
                        : Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                    blurRadius: isHighlight ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Emoji Avatar in Soft Colored Circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: activeMoodColor.withValues(alpha: isDark ? 0.25 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.mood.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Mood Label
                  Expanded(
                    child: Text(
                      widget.mood.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
                        color: isHighlight
                            ? (isDark ? activeMoodColor : activeMoodColor)
                            : colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  // Selection Radio / Check indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isHighlight
                          ? activeMoodColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isHighlight
                            ? activeMoodColor
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                        width: isHighlight ? 0 : 2,
                      ),
                    ),
                    child: isHighlight
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
