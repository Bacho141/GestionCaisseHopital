import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/models/navigation_items.dart';
import 'package:migo/view/home/home_dashboard.dart';
import 'package:migo/view/receipt/create_receipt.dart';
import 'package:migo/view/servicemedical/servicemedical_page.dart';
import 'package:migo/view/history/receipt_history.dart';
import 'package:migo/view/analytics/analyticspage.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/settings/settingspage.dart';

/// Panel de navigation qui s'affiche à gauche (desktop) ou en bas (mobile).
class NavigationPanel extends StatefulWidget {
  final Axis axis;
  final int activeTab;

  const NavigationPanel({
    Key? key,
    required this.axis,
    required this.activeTab,
  }) : super(key: key);

  @override
  State<NavigationPanel> createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  final Color primaryColor = const Color(0xFF7717E8);
  final Color inactiveColor = const Color(0xFF9E9E9E);

  // On récupère l'AuthController existant pour lire userRole
  final AuthController _authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Role en cours : 'Admin' ou 'Agent'
      final isAdmin = _authCtrl.userRole.value == 'Admin';

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
                    offset: const Offset(2, 0),
                  ),
                ]
              : [],
        ),
        margin: const EdgeInsets.all(0),
        child: widget.axis == Axis.vertical
            // --------------------
            // Version Desktop
            // --------------------
            ? Column(
                children: [
                  // Logo en haut
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        if (isAdmin) {
                          Get.to(
                            () => const DashboardPage(),
                            transition: Transition.noTransition,
                          );
                        } else {
                          // Si Agent, on redirige vers ProductsPage par défaut
                          Get.to(
                            () => const ProductsPage(),
                            transition: Transition.noTransition,
                          );
                        }
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
                        children: [

                          // ── DASHBOARD (Admin seulement) ──
                          if (isAdmin)
                            _buildNavButton(
                              icon: NavigationItems.dashboard.icon,
                              isActive: widget.activeTab == NavigationItems.dashboard.index,
                              tooltip: NavigationItems.dashboard.name,
                              onPressed: () {
                                Get.to(
                                  () => const DashboardPage(),
                                  transition: Transition.noTransition,
                                );
                              },
                            ),

                          // ── CREATE RECEIPT (Tous) ──
                          _buildNavButton(
                            icon: NavigationItems.receipts.icon,
                            isActive: widget.activeTab == NavigationItems.receipts.index,
                            tooltip: "Reçu",
                            onPressed: () {
                              Get.to(
                                () => const CreateReceipt(),
                                transition: Transition.noTransition,
                              );
                            },
                          ),

                          // ── PRODUCTS (Tous) ──
                          _buildNavButton(
                            icon: NavigationItems.products.icon,
                            isActive: widget.activeTab == NavigationItems.products.index,
                            tooltip: "Services",
                            onPressed: () {
                              Get.to(
                                () => const ProductsPage(),
                                transition: Transition.noTransition,
                              );
                            },
                          ),

                          // ── HISTORICS (Tous) ──
                          _buildNavButton(
                            icon: NavigationItems.historics.icon,
                            isActive: widget.activeTab == NavigationItems.historics.index,
                            tooltip: "Historiques",
                            onPressed: () {
                              Get.to(
                                () => const ReceiptHistory(),
                                transition: Transition.noTransition,
                              );
                            },
                          ),

                          // ── ANALYTICS (Admin seulement) ──
                          if (isAdmin)
                            _buildNavButton(
                              icon: NavigationItems.analytics.icon,
                              isActive: widget.activeTab == NavigationItems.analytics.index,
                              tooltip: "Analyse",
                              onPressed: () {
                                Get.to(
                                  () => const AnalyticsPage(),
                                  transition: Transition.noTransition,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ── SETTINGS (Admin seulement) ──
                  if (isAdmin)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: widget.activeTab == 5
                            ? primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Iconsax.setting,
                          color: widget.activeTab == 5
                              ? primaryColor
                              : inactiveColor,
                          size: 26,
                        ),
                        tooltip: "Paramètre",
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
            // --------------------
            // Version Mobile
            // --------------------
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ── DASHBOARD (Admin seulement) ──
                    if (isAdmin)
                      _buildMobileNavItem(
                        icon: NavigationItems.dashboard.icon,
                        isActive: widget.activeTab == NavigationItems.dashboard.index,
                        onPressed: () {
                          Get.to(
                            () => const DashboardPage(),
                            transition: Transition.noTransition,
                          );
                        },
                      ),

                    // ── CREATE RECEIPT (Tous) ──
                    _buildMobileNavItem(
                      icon: NavigationItems.receipts.icon,
                      isActive: widget.activeTab == NavigationItems.receipts.index,
                      onPressed: () {
                        Get.to(
                          () => const CreateReceipt(),
                          transition: Transition.noTransition,
                        );
                      },
                    ),

                    // ── PRODUCTS (Tous) ──
                    _buildMobileNavItem(
                      icon: NavigationItems.products.icon,
                      isActive: widget.activeTab == NavigationItems.products.index,
                      onPressed: () {
                        Get.to(
                          () => const ProductsPage(),
                          transition: Transition.noTransition,
                        );
                      },
                    ),

                    // ── HISTORICS (Tous) ──
                    if (!isAdmin)
                      _buildMobileNavItem(
                        icon: NavigationItems.historics.icon,
                        isActive: widget.activeTab == NavigationItems.historics.index,
                        onPressed: () {
                          Get.to(
                            () => const ReceiptHistory(),
                            transition: Transition.noTransition,
                          );
                        },
                      ),

                    // ── ANALYTICS (Admin seulement) ──
                    if (isAdmin)
                      _buildMobileNavItem(
                        icon: NavigationItems.analytics.icon,
                        isActive: widget.activeTab == NavigationItems.analytics.index,
                        onPressed: () {
                          Get.to(
                            () => const AnalyticsPage(),
                            transition: Transition.noTransition,
                          );
                        },
                      ),

                    // ── SETTINGS (Admin seulement) ──
                    if (isAdmin)
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
    });
  }

  /// Bouton vertical (desktop)
  Widget _buildNavButton({
    required IconData icon,
    required bool isActive,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? primaryColor : inactiveColor,
          size: 26,
        ),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  /// Bouton horizontal (mobile)
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
