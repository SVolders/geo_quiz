import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_quiz/data/countries.dart';

class FlagButton extends StatelessWidget {
  const FlagButton({
    super.key,
    required this.country,
    required this.isSelected,
    required this.isCorrect,
    required this.onPressed,
  });

  final Country country;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderColor = isSelected
        ? isCorrect
              ? colors.primary
              : colors.error
        : colors.outlineVariant;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Center(
          child: country.flagSvg == null
              ? const Icon(Icons.flag_outlined)
              : SvgPicture.network(
                  country.flagSvg!,
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
