// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:flutter/material.dart';

// class AgentRow {
//   final String id, nom, prenom, adresse, telephone;
//   AgentRow({
//     required this.id,
//     required this.nom,
//     required this.prenom,
//     required this.adresse,
//     required this.telephone,
//   });
// }

// class AgentDataGridSource extends DataGridSource {
//   List<AgentRow> agents;
//   AgentDataGridSource(this.agents) {
//     buildDataGridRows();
//   }
//   List<DataGridRow> _rows = [];
//   void buildDataGridRows() {
//     _rows = agents.map((a) {
//       return DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'ID', value: a.id),
//         DataGridCell<String>(columnName: 'Nom', value: a.nom),
//         DataGridCell<String>(columnName: 'Prénom', value: a.prenom),
//         DataGridCell<String>(columnName: 'Adresse', value: a.adresse),
//         DataGridCell<String>(columnName: 'Téléphone', value: a.telephone),
//       ]);
//     }).toList();
//   }

//   @override
//   List<DataGridRow> get rows => _rows;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(cells: row.getCells().map((cell) {
//       return Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(8),
//         child: Text(cell.value.toString()),
//       );
//     }).toList());
//   }
// }

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:migo/models/agent/agent_row.dart'; // Ajustez le chemin selon votre structure
import 'package:migo/widgets/agent/agent_modals.dart'; // Ajustez le chemin selon votre structure

class AgentDataGridSource extends DataGridSource {
  AgentDataGridSource({
    required this.context,
    required this.agentCtrl,
    required this.agentRows,
    required this.onEdit,
  }) {
    buildDataGridRows();
  }

  final BuildContext context;
  final AgentController agentCtrl;
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
                    onPressed: () async {
                      final confirmed = await showDeleteConfirmation(context, agent);
                      if (confirmed == true) {
                        await agentCtrl.removeAgent(agent.id.toString());
                      }
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