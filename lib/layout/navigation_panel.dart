import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/models/navigation_items.dart';
import 'package:migo/view/home/home_dashboard.dart';
import 'package:migo/view/receipt/create_receipt.dart';
import 'package:migo/view/products/productpage.dart';
import 'package:migo/view/analytics/analyticspage.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/settings/settingspage.dart';

class NavigationPanel extends StatefulWidget {
  final Axis axis;
  final int activeTab;
  const NavigationPanel({Key? key, required this.axis, required this.activeTab})
      : super(key: key);

  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  final Color primaryColor = const Color(0xFF7717E8);
  final Color inactiveColor = const Color(0xFF9E9E9E);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        border: !Responsive.isMobile(context)
            ? Border(
                right: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.0,
                ),
              )
            : null,
        boxShadow: !Responsive.isMobile(context)
      ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 0), // Ombre vers la droite
          ),
        ]
      : [],
      ),
      margin: const EdgeInsets.all(0),
      child: widget.axis == Axis.vertical
          ? Column(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const ProductsPage(),
                        transition: Transition.noTransition,
                      );
                    },
                    child: Image.asset(
                      "assets/logo.png",
                      height: 40,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Menu items
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: NavigationItems.values.map((e) {
                        bool isActive = widget.activeTab == e.index;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(
                              e.icon,
                              color: isActive ? primaryColor : inactiveColor,
                              size: 26,
                            ),
                            tooltip: e.name,
                            onPressed: () {
                              switch (e) {
                                case NavigationItems.dashboard:
                                  Get.to(() => const DashboardPage(),
                                      transition: Transition.noTransition);
                                  break;
                                case NavigationItems.receipts:
                                  Get.to(() => const CreateReceipt(),
                                      transition: Transition.noTransition);
                                  break;
                                case NavigationItems.products:
                                  Get.to(() => const ProductsPage(),
                                      transition: Transition.noTransition);
                                  break;
                                case NavigationItems.analytics:
                                  Get.to(() => const AnalyticsPage(),
                                      transition: Transition.noTransition);
                                  break;
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Settings button
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: widget.activeTab == 5 ? primaryColor.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Iconsax.setting,
                      color: widget.activeTab == 5 ? primaryColor : inactiveColor,
                      size: 26,
                    ),
                    tooltip: "Settings",
                    onPressed: () {
                      Get.to(
                        () => const SettingsPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                ),
              ],
            )
          : Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMobileNavItem(
                    icon: NavigationItems.dashboard.icon,
                    isActive: widget.activeTab == 0,
                    onPressed: () {
                      Get.to(
                        () => const DashboardPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                  _buildMobileNavItem(
                    icon: NavigationItems.receipts.icon,
                    isActive: widget.activeTab == 1,
                    onPressed: () {
                      Get.to(
                        () => const CreateReceipt(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                  _buildMobileNavItem(
                    icon: NavigationItems.products.icon,
                    isActive: widget.activeTab == 2,
                    onPressed: () {
                      Get.to(
                        () => const ProductsPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                  _buildMobileNavItem(
                    icon: NavigationItems.analytics.icon,
                    isActive: widget.activeTab == 3,
                    onPressed: () {
                      Get.to(
                        () => const AnalyticsPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                  _buildMobileNavItem(
                    icon: Iconsax.setting,
                    isActive: widget.activeTab == 5,
                    onPressed: () {
                      Get.to(
                        () => const SettingsPage(),
                        transition: Transition.noTransition,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildMobileNavItem({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isActive ? primaryColor : inactiveColor,
          size: 24,
        ),
      ),
    );
  }
}