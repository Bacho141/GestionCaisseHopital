import 'package:iconsax/iconsax.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:migo/service/settings_service.dart';
import 'package:migo/models/authManager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Vendor {
  Vendor(this.name, this.email);

  final String name;
  final String email;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController firstnameController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController oldPasswordController = TextEditingController();
  late TextEditingController newPasswordController = TextEditingController();

  final SettingsService _settingsService = Get.put(SettingsService());
  final AuthenticationManager _authMgr = Get.find<AuthenticationManager>();

  // États pour l'édition
  bool isEditingFirstname = false;
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isLoading = false;
  bool isLoadingPassword = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadUserProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    firstnameController.dispose();
    nameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  /// Charge le profil utilisateur depuis le backend
  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);

    try {
      final profile = await _settingsService.getProfile();
      if (profile != null) {
        setState(() {
          firstnameController.text = profile['firstname'] ?? '';
          nameController.text = profile['name'] ?? '';
          emailController.text = profile['email'] ?? '';
        });
      } else {
        // Fallback: essayer de récupérer depuis le token JWT
        final token = await _authMgr.getToken();
        if (token != null && !JwtDecoder.isExpired(token)) {
          final decoded = JwtDecoder.decode(token);
          setState(() {
            firstnameController.text = decoded['firstname'] ?? '';
            nameController.text = decoded['name'] ?? '';
            emailController.text = decoded['email'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Erreur chargement profil: $e');
      Get.snackbar(
        'Erreur',
        'Erreur de connexion au backend',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Sauvegarde le profil utilisateur
  Future<void> _saveProfile() async {
    // Validation côté client
    if (firstnameController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Tous les champs sont requis',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Validation email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      Get.snackbar(
        'Erreur',
        'Format d\'email invalide',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await _settingsService.updateProfile(
        firstname: firstnameController.text.trim(),
        name: nameController.text.trim(),
        email: emailController.text.trim(),
      );

      if (success) {
        Get.snackbar(
          'Succès',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        // Désactiver l'édition
        setState(() {
          isEditingFirstname = false;
          isEditingName = false;
          isEditingEmail = false;
        });
      } else {
        Get.snackbar(
          'Erreur',
          'Erreur lors de la sauvegarde',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur de connexion au backend',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showPasswordChangeModal() {
    // Réinitialiser les contrôleurs
    oldPasswordController.clear();
    newPasswordController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ContentBox(
            oldPasswordController: oldPasswordController,
            newPasswordController: newPasswordController,
            onSavePassword: _changePassword,
            isLoading: isLoadingPassword,
          ),
        );
      },
    );
  }

  /// Change le mot de passe
  Future<void> _changePassword() async {
    if (oldPasswordController.text.trim().isEmpty ||
        newPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Tous les champs sont requis',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Validation du nouveau mot de passe
    if (newPasswordController.text.length < 6) {
      Get.snackbar(
        'Erreur',
        'Le nouveau mot de passe doit contenir au moins 6 caractères',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoadingPassword = true);

    try {
      final result = await _settingsService.changePassword(
        oldPassword: oldPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      if (result['success']) {
        Navigator.of(context).pop(); // Fermer le modal
        Get.snackbar(
          'Succès',
          result['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Erreur',
          result['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur de connexion au backend',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoadingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      activeTab: 5,
      pageName: "Settings",
      content: SizedBox(
        width: !Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width - 320
            : MediaQuery.of(context).size.width,
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.black54,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8D7BFF)],
                  ),
                ),
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Iconsax.user,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text("Profile Settings",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          // Profile avatar
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Neumorphic(
                                style: NeumorphicStyle(
                                  shape: NeumorphicShape.concave,
                                  boxShape: const NeumorphicBoxShape.circle(),
                                  depth: 8,
                                  lightSource: LightSource.topLeft,
                                  color: Colors.white,
                                ),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "BS",
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6A5AE0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: NeumorphicButton(
                                  style: const NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.circle(),
                                    depth: 4,
                                    intensity: 0.8,
                                    color: Color(0xFF6A5AE0),
                                  ),
                                  onPressed: () {},
                                  child: const Icon(
                                    Iconsax.camera,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Loading indicator
                          if (isLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF6A5AE0)),
                              ),
                            ),

                          // Form fields
                          if (!isLoading) ...[
                            _buildInputField(
                              controller: firstnameController,
                              label: "Prénom",
                              icon: Iconsax.user,
                              isEditing: isEditingFirstname,
                              onEditToggle: () {
                                setState(() {
                                  isEditingFirstname = !isEditingFirstname;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              controller: nameController,
                              label: "Nom",
                              icon: Iconsax.user_edit,
                              isEditing: isEditingName,
                              onEditToggle: () {
                                setState(() {
                                  isEditingName = !isEditingName;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              controller: emailController,
                              label: "Email",
                              icon: Iconsax.sms,
                              isEditing: isEditingEmail,
                              onEditToggle: () {
                                setState(() {
                                  isEditingEmail = !isEditingEmail;
                                });
                              },
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Password button
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: SizedBox(
                              width: double.infinity,
                              child: _HoverNeumorphicButton(
                                onPressed: () {
                                  _showPasswordChangeModal();
                                },
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.lock,
                                      color: Color(0xFF6A5AE0),
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Changer le  mot de passe",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6A5AE0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Save button
                          SizedBox(
                            width: double.infinity,
                            child: NeumorphicButton(
                              style: NeumorphicStyle(
                                depth: 0,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                                color: Color(0xFF6A5AE0),
                              ),
                              onPressed: isLoading ? null : _saveProfile,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isLoading)
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Iconsax.tick_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isLoading
                                        ? "Sauvegarde..."
                                        : "Save Changes",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isEditing,
    required VoidCallback onEditToggle,
  }) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF6A5AE0),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEditing,
              style: TextStyle(
                color: isEditing ? Colors.black87 : Colors.black54,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: isEditing ? Colors.black45 : Colors.black38,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              ),
            ),
          ),
          // Edit button
          SizedBox(width: 20),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onEditToggle,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isEditing
                        ? [Colors.green, Colors.green.shade400]
                        : [Color(0xFF6A5AE0), Color(0xFF8D7BFF)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: (isEditing ? Colors.green : Color(0xFF6A5AE0))
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isEditing ? Icons.check : Iconsax.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// HoverNeumorphicButton for the hover effect on the Change Password button
class _HoverNeumorphicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _HoverNeumorphicButton({
    required this.onPressed,
    required this.child,
    required this.padding,
  });

  @override
  _HoverNeumorphicButtonState createState() => _HoverNeumorphicButtonState();
}

class _HoverNeumorphicButtonState extends State<_HoverNeumorphicButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: NeumorphicButton(
        style: NeumorphicStyle(
          depth: isHovered ? 2 : 4,
          intensity: isHovered ? 0.9 : 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          color: isHovered ? const Color(0xFFF5F5FF) : Colors.white,
          border: isHovered
              ? const NeumorphicBorder(
                  color: Color(0xFFD9D6FF),
                  width: 1,
                )
              : const NeumorphicBorder(
                  // Ajout d'une bordure par défaut
                  color: Colors.transparent, // Bordure invisible
                  width: 0,
                ),
        ),
        onPressed: widget.onPressed,
        padding: widget.padding as EdgeInsets?,
        child: widget.child,
      ),
    );
  }
}

// Password Change Modal Widget
class ContentBox extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final VoidCallback onSavePassword;
  final bool isLoading;

  const ContentBox({
    Key? key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.onSavePassword,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A5AE0),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Old Password Field
            _buildPasswordField(
              controller: oldPasswordController,
              label: "Ancien mot de passe",
              isOldPassword: true,
            ),

            const SizedBox(height: 16),

            // New Password Field
            _buildPasswordField(
              controller: newPasswordController,
              label: "Nouveau mot de passe",
              isOldPassword: false,
            ),

            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8D7BFF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A5AE0).withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Save password logic here
                      onSavePassword();
                    },
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Save Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isOldPassword,
  }) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.6,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            isOldPassword ? Iconsax.unlock : Iconsax.lock,
            color: Colors.black45,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: true,
              style: const TextStyle(
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: Colors.black45,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
