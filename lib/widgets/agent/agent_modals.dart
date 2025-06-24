import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:migo/models/agent/agent.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/models/agent/agent_row.dart'; // Ajustez le chemin selon votre structure

/// Affiche un dialog de confirmation Neumorphic avant suppression
Future<bool?> showDeleteConfirmation(BuildContext context, AgentRow agent) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // Permet de fermer en cliquant à l'extérieur
    builder: (_) => Neumorphic(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      style: NeumorphicStyle(
        depth: -8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Supprimer cet agent ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '${agent.prenom} ${agent.nom}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(depth: 4),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                NeumorphicButton(
                  style: NeumorphicStyle(color: Colors.redAccent, depth: 4),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Supprimer', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future<void> showAgentPasswordModal(
  BuildContext context,
  String agentId,
  AgentController controller,
) async {
  final _adminPwdCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? revealed;

  await showDialog(
    context: context,
    barrierDismissible: true, // Permet de fermer en cliquant à l'extérieur
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Mot de passe administrateur'),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // — Le formulaire de saisie du mot de passe admin
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _adminPwdCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Votre mot de passe',
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                ),
              ),
              const SizedBox(height: 16),
              // — Si le pwd est révélé, on l'affiche
              if (revealed != null) ...[
                SelectableText(
                  "Mot de passe de l'agent : $revealed",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: revealed!));
                    Get.snackbar('Copié', 'Mot de passe copié');
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copier'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _adminPwdCtrl.dispose();
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                // <-- Ici on appelle revealPassword et on récupère le booléen
                // TODO: Remplacer par l'ID admin réel au lieu de l'ID hardcodé
                final ok = await controller.revealPassword(
                  "682adcfce06afc005bb63f62", // TODO: Récupérer l'ID admin depuis le backend
                  _adminPwdCtrl.text.trim(),
                );
                if (ok) {
                  // Si tout est OK, on affiche le mot de passe
                  setState(() {
                    revealed = controller.revealedPassword.value;
                  });
                } else {
                  // Sinon, on signale l'erreur
                  Get.snackbar(
                    'Erreur',
                    'Impossible de révéler : vérifiez votre mot de passe admin.',
                    backgroundColor: Colors.redAccent,
                  );
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    ),
  ).whenComplete(() {
    // Nettoie les ressources quand le dialog se ferme
    _adminPwdCtrl.dispose();
  });
}

Future<void> showEditAgentModal({
  required BuildContext context,
  required BuildContext dialogContext,
  // required BuildContext parentScaffoldContext,
  required AgentRow agent,
  required VoidCallback? onSave, // Peut être null
}) async {
  final TextEditingController nomController = TextEditingController(text: agent.nom);
  final TextEditingController prenomController = TextEditingController(text: agent.prenom);
  final TextEditingController adresseController = TextEditingController(text: agent.adresse);
  final TextEditingController telephoneController = TextEditingController(text: agent.telephone);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AgentController agentCtrl = Get.find<AgentController>();

  // Réinitialise le mot de passe révélé
  agentCtrl.revealedPassword.value = null;

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) return;

    final updated = Agent(
      id: agent.id,
      nom: nomController.text.trim(),
      prenom: prenomController.text.trim(),
      adresse: adresseController.text.trim(),
      telephone: telephoneController.text.trim(),
    );

    final result = await agentCtrl.updateAgent(agent.id, updated);

    if (result != null) {
      Navigator.of(dialogContext).pop();
      // Message de succès
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     // content: Text('Agent modifié avec succès'),
      //     // backgroundColor: Colors.green,
      //     // duration: Duration(seconds: 2),
          
      //   ),
      // );
      Get.snackbar(
        'Succès',
        'Agent modifié avec succès',
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      );

      // Appelle le callback si fourni
      onSave?.call();
    } else {
      Get.snackbar(
        'Erreur', 
        'La modification a échoué',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  Widget buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromARGB(152, 121, 23, 232),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red.shade300,
                width: 1,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  final bool isMobile = Responsive.isMobile(context);

  await showDialog(
    context: context,
    barrierDismissible: true, // CORRECTION: Permet de fermer en cliquant à l'extérieur
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: isMobile ? double.infinity : 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.edit,
                    color: Color.fromARGB(152, 121, 23, 232),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Modifier l'agent",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 16),

              // Form
              Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFormField(
                        label: 'Nom',
                        controller: nomController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildFormField(
                        label: 'Prénom',
                        controller: prenomController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un prénom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildFormField(
                        label: 'Adresse',
                        controller: adresseController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une adresse';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildFormField(
                        label: 'Téléphone',
                        controller: telephoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un numéro de téléphone';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Veuillez entrer un numéro valide';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      Obx(() {
                        // Si on a chargé un mot de passe révélé, on l'affiche en clair
                        final pwd = agentCtrl.revealedPassword.value;
                        return Row(
                          children: [
                            const Text(
                              'Mot de passe : ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Text(
                                pwd != null ? pwd : '********',
                                style: const TextStyle(letterSpacing: 2),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                // Ouvre la modale de vérification admin, puis reveal
                                showAgentPasswordModal(
                                  context,
                                  agent.id,
                                  agentCtrl,
                                );
                              },
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 24),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Annuler'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(152, 121, 23, 232),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Enregistrer'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    // CORRECTION: Nettoie les ressources quand le dialog se ferme (quelque soit la façon)
    nomController.dispose();
    prenomController.dispose();
    adresseController.dispose();
    telephoneController.dispose();
    // Réinitialise le mot de passe révélé
    agentCtrl.revealedPassword.value = null;
  });
}