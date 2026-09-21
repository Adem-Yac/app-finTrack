import 'package:fintrack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryStyle {
  static IconData icon(String? slug) {
    return switch (slug) {
      'food' => Icons.shopping_cart_rounded,
      'restaurant' => Icons.restaurant_rounded,
      'transport' => Icons.local_gas_station_rounded,
      'shopping' => Icons.shopping_bag_rounded,
      'bills' => Icons.receipt_long_rounded,
      'housing' => Icons.home_rounded,
      'health' => Icons.medical_services_rounded,
      'education' => Icons.school_rounded,
      'entertainment' => Icons.movie_rounded,
      'salary' => Icons.payments_rounded,
      _ => Icons.category_rounded,
    };
  }

  static Color tint(String? slug) {
    return switch (slug) {
      'food' => const Color(0xFFE8F0EA),
      'restaurant' => const Color(0xFFF3EDE4),
      'transport' => const Color(0xFFE7EEEA),
      'health' => const Color(0xFFFBEAE5),
      'entertainment' => const Color(0xFFEEF2EA),
      'salary' => const Color(0xFFE8F5E9),
      'bills' => const Color(0xFFF4F3F0),
      _ => AppColors.surfaceLow,
    };
  }

  static String paymentLabel(String? method) {
    return switch (method) {
      'cash' => 'En espèces',
      'cib' => 'Carte CIB',
      'transfer' => 'Virement bancaire',
      'online' => 'Paiement en ligne',
      _ => method ?? '',
    };
  }
}
