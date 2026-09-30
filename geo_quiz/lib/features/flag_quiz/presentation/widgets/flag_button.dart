import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_quiz/data/models/country.dart';

class FlagButton extends StatelessWidget {
  const FlagButton({
    super.key,
    required this.country,
    required this.isSelected,
    required this.isCorrect,
    required this.isRevealed,
    required this.onPressed,
  });

  final Country country;
  final bool isSelected;
  final bool isCorrect;

  /// True once the question has been answered: the correct flag is shown
  /// regardless of what the player picked, and tapping does nothing.
  final bool isRevealed;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final Color borderColor;
    if (isRevealed && isCorrect) {
      borderColor = colors.primary;
    } else if (isSelected) {
      borderColor = colors.error;
    } else {
      borderColor = colors.outlineVariant;
    }

    final isHighlighted = isSelected || (isRevealed && isCorrect);

    return InkWell(
      onTap: isRevealed ? null : onPressed,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isHighlighted ? 2 : 1),
        ),
        child: Center(
          child: SvgPicture.network(
            country.flagSvg,
            fit: BoxFit.contain,
            placeholderBuilder: (_) => const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorBuilder: (_, _, _) => const Icon(Icons.flag_outlined),
          ),
        ),
      ),
    );
  }
}
