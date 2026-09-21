import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_scale.dart';
import 'package:fintrack/core/theme/app_text.dart';
import 'package:fintrack/presentation/widgets/ui_kit.dart';
import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 96, this.circle = true});

  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return AppLogo(size: size, circle: circle);
  }
}

class SoftPill extends StatelessWidget {
  const SoftPill({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.background,
    this.dot = false,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? background;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background ?? AppColors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            const Icon(Icons.circle, size: 8, color: AppColors.logo),
            const SizedBox(width: 8),
          ],
          if (icon != null) ...[
            Icon(icon, size: scale.iconSm, color: color ?? AppColors.secondary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppText.labelMd(
              context,
              color: color ?? AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthHeaderBar extends StatelessWidget {
  const AuthHeaderBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_rounded,
            size: scale.iconLg,
            color: AppColors.onSurface,
          ),
        ),
        const BrandMark(size: 36, circle: false),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FinTrack',
                style: AppText.labelSm(context, color: AppColors.logo),
              ),
              Text(title, style: AppText.headlineSm(context)),
            ],
          ),
        ),
      ],
    );
  }
}

class SoftField extends StatelessWidget {
  const SoftField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscure = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: AppText.bodyLg(context, color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
        ),
      ),
    );
  }
}

class ForestButton extends StatelessWidget {
  const ForestButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: Size.fromHeight(AppScale.of(context).buttonHeight + 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppScale.of(context).iconMd),
            const SizedBox(width: 8),
          ],
          Flexible(child: Text(label, textAlign: TextAlign.center)),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward_rounded, size: AppScale.of(context).iconMd),
        ],
      ),
    );
  }
}
