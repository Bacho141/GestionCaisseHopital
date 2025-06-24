// import 'package:get/get.dart';
// import 'package:migo/utils/custome_drive.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:migo/controller/controller_agent.dart';
// import 'package:migo/view/responsive.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:migo/models/agent/agent_row.dart';
// import 'package:migo/widgets/agent/agent_data_grid_source.dart';
// import 'package:migo/widgets/agent/agent_modals.dart';

// /*
// Nous avons un problème il se trouve que c'est l'id admin qu'on devrait passer en paramètre ici "final ok = await controller.revealPassword(                   agentId,                   _adminPwdCtrl.text.trim(),                 );"pas celui de l'agent, peut tu me trouver un moyen de récupérer l'Id admin depuis le backend.
// après réflexion j'ai juge utile de l'id dès la connexion ou l'inscription.
//  */

// class ManagementAgents extends StatefulWidget {
//   const ManagementAgents({Key? key}) : super(key: key);

//   @override
//   State<ManagementAgents> createState() => _AgentsViewState();
// }

// class _AgentsViewState extends State<ManagementAgents> {
//   // Injecte ton controller GetX
//   final AgentController _agentCtrl = Get.put(AgentController());

//   // Remplace la liste statique par une liste vide
//   List<AgentRow> rows = [];

//   late AgentDataGridSource _agentDataGridSource;

//   @override
//   void initState() {
//     super.initState();
//     // Charge les agents depuis le backend
//     _agentCtrl.fetchAll().then((_) {
//       setState(() {
//         rows = _agentCtrl.agents.map((a) => AgentRow(
//           id: a.id!,
//           nom: a.nom,
//           prenom: a.prenom,
//           adresse: a.adresse,
//           telephone: a.telephone,
//         )).toList();
//         _initializeDataSource();
//       });
//       print('>> Agents chargés (${_agentCtrl.agents.length}): ${_agentCtrl.agents.map((a) => a.id).toList()}');
//     });
//   }

//   void _initializeDataSource() {
//     _agentDataGridSource = AgentDataGridSource(
//       context: context,
//       agentCtrl: _agentCtrl,
//       agentRows: rows,
//       onEdit: _handleEditAgent,
//     );
//   }

//   void _handleEditAgent(AgentRow agent) {
//     showEditAgentModal(
//       dialogContext: context, 
//       context: context,
//       agent: agent,
//       onSave: () {
//         // Callback appelé après sauvegarde réussie
//         // La mise à jour se fera automatiquement via Obx
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = Responsive.isMobile(context);

//     return Container(
//       width: isMobile ? double.infinity : MediaQuery.of(context).size.width * 0.55,
//       height: isMobile ? null : 500,
//       margin: EdgeInsets.all(isMobile ? 8 : 16),
//       padding: EdgeInsets.all(isMobile ? 12 : 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: isMobile ? 8 : 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header with title
//           Row(
//             children: [
//               Neumorphic(
//                 style: NeumorphicStyle(
//                   depth: 4,
//                   intensity: 0.8,
//                   shape: NeumorphicShape.flat,
//                   boxShape: NeumorphicBoxShape.circle(),
//                   color: const Color.fromARGB(152, 121, 23, 232),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Icon(
//                     Icons.people,
//                     size: isMobile ? 18 : 20,
//                     color: const Color(0xFFFFFFFF),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Text(
//                 "Liste des Agents",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: isMobile ? 8 : 12),
//           const CustomDivider(),
//           SizedBox(height: isMobile ? 16 : 30),

//           // Data grid or List view based on screen size
//           Obx(() {
//             // À chaque fois que _agentCtrl.agents change, on recalcule rows et on rebuild
//             rows = _agentCtrl.agents.map((a) => AgentRow(
//               id: a.id!,
//               nom: a.nom,
//               prenom: a.prenom,
//               adresse: a.adresse,
//               telephone: a.telephone,
//             )).toList();
//             _initializeDataSource();

//             return isMobile ? _buildMobileView() : _buildDesktopView();
//           })
//         ],
//       ),
//     );
//   }

//   Widget _buildMobileView() {
//     return SizedBox(
//       height: 400, // Fixed height for scrollable content
//       child: rows.isEmpty
//           ? const Center(
//               child: Text('Aucune donnée trouvée !'),
//             )
//           : ListView.builder(
//               itemCount: rows.length,
//               itemBuilder: (context, index) {
//                 final agent = rows[index];
//                 return Card(
//                   elevation: 2,
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   child: ExpansionTile(
//                     title: Text(
//                       '${agent.prenom} ${agent.nom}',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(agent.telephone),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildAgentInfoRow('Adresse:', agent.adresse),
//                             const SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 // Delete button
//                                 _buildActionButton(
//                                   icon: Icons.delete,
//                                   color: Colors.red,
//                                   label: 'Supprimer',
//                                   onPressed: () async {
//                                     final confirmed = await showDeleteConfirmation(context, agent);
//                                     if (confirmed == true) {
//                                       await _agentCtrl.removeAgent(agent.id.toString());
//                                     }
//                                   },
//                                 ),
//                                 const SizedBox(width: 12),
//                                 // Edit button
//                                 _buildActionButton(
//                                   icon: Icons.edit,
//                                   color: Colors.blue,
//                                   label: 'Modifier',
//                                   onPressed: () => _handleEditAgent(agent),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   Widget _buildAgentInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black54,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(8),
//           onTap: onPressed,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, color: color, size: 18),
//                 const SizedBox(width: 4),
//                 Text(
//                   label,
//                   style: TextStyle(color: color, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDesktopView() {
//     return SizedBox(
//       height: 320,
//       child: rows.isEmpty
//           ? const Center(
//               child: Text('Aucune donnée trouvée !'),
//             )
//           : SfDataGrid(
//               columnWidthMode: ColumnWidthMode.fill,
//               source: _agentDataGridSource,
//               columns: <GridColumn>[
//                 GridColumn(
//                   columnName: 'nom',
//                   label: Container(
//                     padding: const EdgeInsets.all(8),
//                     alignment: Alignment.centerLeft,
//                     child: const Text('Nom'),
//                   ),
//                 ),
//                 GridColumn(
//                   columnName: 'prenom',
//                   label: Container(
//                     padding: const EdgeInsets.all(8),
//                     alignment: Alignment.centerLeft,
//                     child: const Text('Prenom'),
//                   ),
//                 ),
//                 GridColumn(
//                   columnName: 'adresse',
//                   label: Container(
//                     padding: const EdgeInsets.all(8),
//                     alignment: Alignment.centerLeft,
//                     child: const Text('Adresse'),
//                   ),
//                 ),
//                 GridColumn(
//                   columnName: 'telephone',
//                   label: Container(
//                     padding: const EdgeInsets.all(8),
//                     alignment: Alignment.centerLeft,
//                     child: const Text('Téléphone'),
//                   ),
//                 ),
//                 GridColumn(
//                   columnName: 'actions',
//                   label: Container(
//                     padding: const EdgeInsets.all(8),
//                     alignment: Alignment.center,
//                     child: const Text('Actions'),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }