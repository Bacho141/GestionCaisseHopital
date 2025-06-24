import 'package:get/get.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:migo/view/responsive.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:migo/models/agent/agent_row.dart';
import 'package:migo/models/agent/agent.dart';
import 'package:migo/widgets/agent/agent_data_grid_source.dart';
import 'package:flutter/services.dart'; 


/// Affiche un dialog de confirmation Neumorphic avant suppression
Future<bool?> showDeleteConfirmation(BuildContext context, AgentRow agent) {
  return showDialog<bool>(
  context: context,
  builder: (_) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5, // Max 50% de la hauteur de l'écran
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Empêche l'expansion inutile
          children: [
            const Text(
              'Supprimer cet agent ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Espacement réduit
            Text(
              '${agent.prenom} ${agent.nom}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16), // Espacement réduit
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(depth: 4),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Taille réduite
                    child: Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 8),
                NeumorphicButton(
                  style: NeumorphicStyle(color: Colors.redAccent, depth: 4),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Taille réduite
                    child: Text('Supprimer', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
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
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Mot de passe administrateur',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
            ),
          ),
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
              // — Si le pwd est révélé, on l’affiche
              if (revealed != null) ...[
                SelectableText(
                  'Mot de passe de l’agent : $revealed',
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                // <-- Ici on appelle revealPassword et on récupère le booléen
                final ok = await controller.revealPassword(
                  agentId,
                  _adminPwdCtrl.text.trim(),
                );
                if (ok) {
                  // Si tout est OK, on affiche le mot de passe
                  setState(() {
                    revealed = controller.revealedPassword.value;
                  });
                  Get.snackbar(
                    'Succès',
                    'Mot de passe correcte',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                } else {
                  // Sinon, on signale l'erreur
                  Get.snackbar(
                    'Erreur',
                    'Impossible de révéler : vérifiez votre mot de passe admin.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Valider'),
            ),

          ],
        );
      },
    ),
  );
}


class ManagementAgents extends StatefulWidget {
  const ManagementAgents({Key? key}) : super(key: key);

  @override
  State<ManagementAgents> createState() => _AgentsViewState();
}

class _AgentsViewState extends State<ManagementAgents> {
 // Injecte ton controller GetX
final AgentController _agentCtrl = Get.put(AgentController());

// Remplace la liste statique par une liste vide
List<AgentRow> rows = [];

  late AgentDataGridSource _agentDataGridSource;
  
  // Form controllers
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _editingAgentId;

  // @override
  // void initState() {
  //   super.initState();
  //   // Charge les agents depuis le backend
  //   _agentCtrl.fetchAll().then((_) {
  //     setState(() {
  //       rows = _agentCtrl.agents.map((a) => AgentRow(
  //         id: a.id!,
  //         nom: a.nom,
  //         prenom: a.prenom,
  //         adresse: a.adresse,
  //         telephone: a.telephone,
  //       )).toList();
  //       _initializeDataSource();
  //     });
  //     print('>> Agents chargés (${_agentCtrl.agents.length}): ${_agentCtrl.agents.map((a) => a.id).toList()}');

  //   });
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _agentCtrl.fetchAll().then((_) {
        setState(() {
          rows = _agentCtrl.agents.map((a) => AgentRow(
            id: a.id!,
            nom: a.nom,
            prenom: a.prenom,
            adresse: a.adresse,
            telephone: a.telephone,
          )).toList();
          _initializeDataSource();
        });
        print('>> Agents chargés (${_agentCtrl.agents.length}): ${_agentCtrl.agents.map((a) => a.id).toList()}');
      });
    });
  }


  void _initializeDataSource() {
    _agentDataGridSource = AgentDataGridSource(
      context: context,
      agentCtrl: _agentCtrl, 
      agentRows: rows,
      onEdit: _showEditModal,
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _adresseController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  void _updateDataSource() {
    setState(() {
      _initializeDataSource();
    });
  }

  void _showEditModal(AgentRow agent) {
    // Set current values in controllers
    _editingAgentId = agent.id;
    if (_editingAgentId == null) {
      // Cas improbable : on ferme immédiatement
      return;
    }
    _nomController.text = agent.nom;
    _prenomController.text = agent.prenom;
    _adresseController.text = agent.adresse;
    _telephoneController.text = agent.telephone;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildEditModal();
      },
    );
  }


  Future<void> _saveChanges() async {
    // 1) On ne fait rien sans ID
    if (_editingAgentId == null) return;

    // 2) Validation du formulaire
    if (!_formKey.currentState!.validate()) return;

    // 3) Création de l'objet Agent à mettre à jour
    final updated = Agent(
      id: _editingAgentId,              // String ID de MongoDB
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      adresse: _adresseController.text.trim(),
      telephone: _telephoneController.text.trim(),
    );

    // 4) Appel API
    final result = await _agentCtrl.updateAgent(_editingAgentId!, updated);

    // 5) Si réussite, on ferme la modal et on rafraîchit automatiquement via Obx
    if (result != null) {
      // setState(() {
      //     // rows = result;
      //     _updateDataSource();
      //   });
      Navigator.of(context).pop();
      // Get.snackbar('Succès', 'Agent modifié');
       Get.snackbar(
        'Succès',
        'Agent modifié avec supprimé',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'La modification a échoué',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }


  Widget _buildEditModal() {
    final bool isMobile = Responsive.isMobile(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
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
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField(
                        label: 'Nom',
                        controller: _nomController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: 'Prénom',
                        controller: _prenomController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un prénom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: 'Adresse',
                        controller: _adresseController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une adresse';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        label: 'Téléphone',
                        controller: _telephoneController,
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
                        // Si on a chargé un mot de passe révélé, on l’affiche en clair
                        final pwd = Get.find<AgentController>().revealedPassword.value;
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
                                  _editingAgentId!,                  // l’ID de l’agent en cours
                                  Get.find<AgentController>(),
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
                            onPressed: _saveChanges,
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
      )
    );
  }

  Widget _buildFormField({
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


  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    
    return Container(
      width: isMobile ? double.infinity : MediaQuery.of(context).size.width * 0.55,
      height: isMobile ? null : 500,
      margin: EdgeInsets.all(isMobile ? 8 : 16),
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: isMobile ? 8 : 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          Row(
            children: [
              Neumorphic(
                style: NeumorphicStyle(
                  depth: 4,
                  intensity: 0.8,
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.circle(),
                  color: const Color.fromARGB(152, 121, 23, 232),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.people,
                    size: isMobile ? 18 : 20,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Liste des Agents",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 12),
          const CustomDivider(),
          SizedBox(height: isMobile ? 16 : 30),
          
          // Data grid or List view based on screen size
          Obx(() {
            // À chaque fois que _agentCtrl.agents change, on recalcule rows et on rebuild
            rows = _agentCtrl.agents.map((a) => AgentRow(
              id: a.id!,
              nom: a.nom,
              prenom: a.prenom,
              adresse: a.adresse,
              telephone: a.telephone,
            )).toList();
            _initializeDataSource();

            return isMobile 
              ? _buildMobileView()
              : _buildDesktopView();
          })

        ],
      ),
    );
  }

  Widget _buildMobileView() {
    return SizedBox(
      height: 400, // Fixed height for scrollable content
      child: rows.isEmpty
          ? const Center(
              child: Text('Aucune donnée trouvée !'),
            )
          : ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final agent = rows[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ExpansionTile(
                    title: Text(
                      '${agent.prenom} ${agent.nom}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(agent.telephone),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAgentInfoRow('Adresse:', agent.adresse),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Delete button
                                _buildActionButton(
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  label: 'Supprimer',
                                  onPressed: () async {
                                    // TODO: Delete action
                                    final confirmed = await showDeleteConfirmation(context, agent);
                                    if (confirmed == true) {
                                      final success = await _agentCtrl.removeAgent(agent.id.toString());
                                      if (success) {
                                        Get.snackbar(
                                          'Succès',
                                          'Agent supprimé',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.green.withOpacity(0.8),
                                          colorText: Colors.white,
                                        );
                                      } else {
                                        Get.snackbar(
                                          'Erreur',
                                          'Impossible de supprimer l’agent',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                                          colorText: Colors.white,
                                        );
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(width: 12),
                                // Edit button
                                _buildActionButton(
                                  icon: Icons.edit,
                                  color: Colors.blue,
                                  label: 'Modifier',
                                  onPressed: () => _showEditModal(agent),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAgentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(color: color, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopView() {
    return SizedBox(
      height: 320,
      child: rows.isEmpty
          ? const Center(
              child: Text('Aucune donnée trouvée !'),
            )
          : SfDataGrid(
              columnWidthMode: ColumnWidthMode.fill,
              source: _agentDataGridSource,
              columns: <GridColumn>[
                GridColumn(
                  columnName: 'nom',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: const Text('Nom'),
                  ),
                ),
                GridColumn(
                  columnName: 'prenom',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: const Text('Prenom'),
                  ),
                ),
                GridColumn(
                  columnName: 'adresse',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: const Text('Adresse'),
                  ),
                ),
                GridColumn(
                  columnName: 'telephone',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: const Text('Téléphone'),
                  ),
                ),
                GridColumn(
                  columnName: 'actions',
                  label: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: const Text('Actions'),
                  ),
                ),
              ],
            ),
    );
  }
}
