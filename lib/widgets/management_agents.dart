// import 'package:migo/utils/custome_drive.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:migo/view/responsive.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

// class ManagementAgents extends StatefulWidget {
//   const ManagementAgents({Key? key}) : super(key: key);

//   @override
//   State<ManagementAgents> createState() => _AgentsViewState();
// }

// class _AgentsViewState extends State<ManagementAgents> {

//   // Simulated agent data
//   List<AgentRow> rows = [
//     AgentRow(nom: 'Dupont', prenom: 'Jean', adresse: '123 Rue A', telephone: '0123456789'),
//     AgentRow(nom: 'Martin', prenom: 'Marie', adresse: '45 Avenue B', telephone: '0987654321'),
//     AgentRow(nom: 'Durand', prenom: 'Paul', adresse: '78 Boulevard C', telephone: '0555123456'),
//     AgentRow(nom: 'Dupont', prenom: 'Jean', adresse: '123 Rue A', telephone: '0123456789'),
//     AgentRow(nom: 'Martin', prenom: 'Marie', adresse: '45 Avenue B', telephone: '0987654321'),
//   ];
//   late AgentDataGridSource _agentDataGridSource;

//   @override
//   void initState() {
//     super.initState();
//     _agentDataGridSource = AgentDataGridSource(rows);
//   }

//   void updateRows(List<AgentRow> newRows) {
//     setState(() {
//       rows = newRows;
//       _agentDataGridSource = AgentDataGridSource(rows);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Responsive.isMobile(context)
//         ? SingleChildScrollView(
//             child: Container(
//               width: 380,
//               margin: const EdgeInsets.all(12),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Neumorphic(
//                         style: NeumorphicStyle(
//                           depth: 4,
//                           intensity: 0.8,
//                           shape: NeumorphicShape.flat,
//                           boxShape: NeumorphicBoxShape.circle(),
//                           color: const Color.fromARGB(152, 121, 23, 232),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: const Icon(
//                             Icons.table_bar,
//                             size: 20,
//                             color: Color(0xFFFFFFFF),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       const Text(
//                         "Tableau des Agents",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const CustomDivider(),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     height: 330,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: SfDataGrid(
//                         columnWidthMode: ColumnWidthMode.auto,
//                         source: _agentDataGridSource,
//                         columns: <GridColumn>[
//                           GridColumn(
//                             columnName: 'nom',
//                             label: Container(
//                               padding: const EdgeInsets.all(6),
//                               alignment: Alignment.centerLeft,
//                               child: const Text('Nom', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           GridColumn(
//                             columnName: 'prenom',
//                             label: Container(
//                               padding: const EdgeInsets.all(6),
//                               alignment: Alignment.centerLeft,
//                               child: const Text('Prenom', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           GridColumn(
//                             columnName: 'adresse',
//                             label: Container(
//                               padding: const EdgeInsets.all(6),
//                               alignment: Alignment.centerLeft,
//                               child: const Text('Adresse', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           GridColumn(
//                             columnName: 'telephone',
//                             label: Container(
//                               padding: const EdgeInsets.all(6),
//                               alignment: Alignment.centerLeft,
//                               child: const Text('Téléphone', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           GridColumn(
//                             columnName: 'actions',
//                             label: Container(
//                               padding: const EdgeInsets.all(6),
//                               alignment: Alignment.center,
//                               child: const Text('Actions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : Container(
//             width: MediaQuery.of(context).size.width * 0.55,
//             height: 500,
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Neumorphic(
//                       style: NeumorphicStyle(
//                         depth: 4,
//                         intensity: 0.8,
//                         shape: NeumorphicShape.flat,
//                         boxShape: NeumorphicBoxShape.circle(),
//                         color: const Color.fromARGB(152, 121, 23, 232),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: const Icon(
//                           Icons.people,
//                           size: 20,
//                           color: Color(0xFFFFFFFF),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text(
//                       "Tableau des Agents",
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 const CustomDivider(),
//                 const SizedBox(height: 30),
//                 Container(
//                   height: 320,
//                   child: rows.isEmpty
//                       ? Center(
//                           child: Text(
//                             'Aucune donnée trouvée !',
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                         )
//                       : SfDataGrid(
//                           columnWidthMode: ColumnWidthMode.fill,
//                           source: _agentDataGridSource,
//                           columns: <GridColumn>[
//                             GridColumn(
//                               columnName: 'nom',
//                               label: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 alignment: Alignment.centerLeft,
//                                 child: const Text('Nom'),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'prenom',
//                               label: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 alignment: Alignment.centerLeft,
//                                 child: const Text('Prenom'),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'adresse',
//                               label: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 alignment: Alignment.centerLeft,
//                                 child: const Text('Adresse'),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'telephone',
//                               label: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 alignment: Alignment.centerLeft,
//                                 child: const Text('Téléphone'),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'actions',
//                               label: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 alignment: Alignment.center,
//                                 child: const Text('Actions'),
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

// class AgentDataGridSource extends DataGridSource {
//   AgentDataGridSource(this.agentRows) {
//     buildDataGridRows();
//   }

//   final List<AgentRow> agentRows;
//   List<DataGridRow> _dataGridRows = [];

//   void buildDataGridRows() {
//     _dataGridRows = agentRows.map<DataGridRow>((r) {
//       return DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'nom', value: r.nom),
//         DataGridCell<String>(columnName: 'prenom', value: r.prenom),
//         DataGridCell<String>(columnName: 'adresse', value: r.adresse),
//         DataGridCell<String>(columnName: 'telephone', value: r.telephone),
//         DataGridCell<Widget>(
//           columnName: 'actions',
//           value: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Delete button (left)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     // TODO: delete action
//                   },
//                 ),
//               ),
//               SizedBox(width: 8),
//               // Edit button (right)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () {
//                     // TODO: edit action
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ]);
//     }).toList();
//   }

//   @override
//   List<DataGridRow> get rows => _dataGridRows;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       cells: row.getCells().map<Widget>((cell) {
//         if (cell.columnName == 'actions') {
//           return Container(
//             padding: const EdgeInsets.all(8),
//             alignment: Alignment.center,
//             child: cell.value,
//           );
//         }
//         return Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8),
//           child: Text(cell.value.toString()),
//         );
//       }).toList(),
//     );
//   }
// }

// class AgentRow {
//   final String nom;
//   final String prenom;
//   final String adresse;
//   final String telephone;

//   AgentRow({
//     required this.nom,
//     required this.prenom,
//     required this.adresse,
//     required this.telephone,
//   });
// }

import 'package:migo/utils/custome_drive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:migo/view/responsive.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ManagementAgents extends StatefulWidget {
  const ManagementAgents({Key? key}) : super(key: key);

  @override
  State<ManagementAgents> createState() => _AgentsViewState();
}

class _AgentsViewState extends State<ManagementAgents> {
  // Simulated agent data
  List<AgentRow> rows = [
    AgentRow(id: 1, nom: 'Dupont', prenom: 'Jean', adresse: '123 Rue A', telephone: '0123456789'),
    AgentRow(id: 2, nom: 'Martin', prenom: 'Marie', adresse: '45 Avenue B', telephone: '0987654321'),
    AgentRow(id: 3, nom: 'Durand', prenom: 'Paul', adresse: '78 Boulevard C', telephone: '0555123456'),
    AgentRow(id: 4, nom: 'Petit', prenom: 'Sophie', adresse: '123 Rue D', telephone: '0678912345'),
    AgentRow(id: 5, nom: 'Bernard', prenom: 'Pierre', adresse: '45 Avenue E', telephone: '0712345678'),
  ];
  late AgentDataGridSource _agentDataGridSource;
  
  // Form controllers
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? _editingAgentId;

  @override
  void initState() {
    super.initState();
    _initializeDataSource();
  }

  void _initializeDataSource() {
    _agentDataGridSource = AgentDataGridSource(
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

  void _saveChanges() {
    if (_formKey.currentState!.validate() && _editingAgentId != null) {
      // Find and update the agent
      final index = rows.indexWhere((agent) => agent.id == _editingAgentId);
      if (index != -1) {
        final updatedRows = List<AgentRow>.from(rows);
        updatedRows[index] = AgentRow(
          id: _editingAgentId!,
          nom: _nomController.text,
          prenom: _prenomController.text,
          adresse: _adresseController.text,
          telephone: _telephoneController.text,
        );
        
        setState(() {
          rows = updatedRows;
          _updateDataSource();
        });
        
        Navigator.of(context).pop(); // Close the modal
        
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agent modifié avec succès'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildEditModal() {
    final bool isMobile = Responsive.isMobile(context);
    
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
          isMobile 
            ? _buildMobileView()
            : _buildDesktopView(),
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
                                  onPressed: () {
                                    // TODO: Delete action
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

class AgentDataGridSource extends DataGridSource {
  AgentDataGridSource({
    required this.agentRows,
    required this.onEdit,
  }) {
    buildDataGridRows();
  }

  final List<AgentRow> agentRows;
  final Function(AgentRow) onEdit;
  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = agentRows.map<DataGridRow>((r) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'nom', value: r.nom),
        DataGridCell<String>(columnName: 'prenom', value: r.prenom),
        DataGridCell<String>(columnName: 'adresse', value: r.adresse),
        DataGridCell<String>(columnName: 'telephone', value: r.telephone),
        DataGridCell<AgentRow>(columnName: 'actions', value: r),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          final agent = cell.value as AgentRow;
          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Delete button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      // TODO: Delete action
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Edit button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: () => onEdit(agent),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}

class AgentRow {
  final int id;
  final String nom;
  final String prenom;
  final String adresse;
  final String telephone;

  AgentRow({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
  });
}