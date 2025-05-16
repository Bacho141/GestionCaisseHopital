import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum NavigationItems {
  dashboard,
  receipts,
  products,
  analytics,
  // employees,
}

extension NavigationItemsExtensions on NavigationItems {
  IconData get icon {
    switch (this) {
      case NavigationItems.dashboard:
        return Icons.dashboard;
      case NavigationItems.receipts:
        return Iconsax.receipt;
      case NavigationItems.products:
        return Iconsax.box;
      case NavigationItems.analytics:
        return Iconsax.chart_square;
      // case NavigationItems.employees:
      // return Iconsax.people;
      default:
        return Iconsax.add;
    }
  }
}
