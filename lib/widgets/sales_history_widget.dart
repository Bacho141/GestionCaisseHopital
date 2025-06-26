import 'package:flutter/material.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:migo/view/responsive.dart';
import 'package:get/get.dart';
import 'package:migo/controller/receipt_controller.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:intl/intl.dart';

class SalesHistoryWidget extends StatefulWidget {
  const SalesHistoryWidget({Key? key}) : super(key: key);

  @override
  State<SalesHistoryWidget> createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryWidget> {
  // Variables d’état pour les filtres
  String period = 'GLOBAL';
  String? selectedCashier;
  String? selectedProduct;
  String? selectedStatus;

  List<InvoiceRow> rows = [];
  late InvoiceDataGridSource _invoiceDataGridSource;

  late final ReceiptController _rc;

  double totalAmount = 0;
  double totalPaid = 0;
  double totalDue = 0;

  void calculateTotals() {
    totalAmount = rows.fold(0, (sum, row) => sum + row.amount);
    totalPaid = rows.fold(0, (sum, row) => sum + row.paid);
    totalDue = rows.fold(0, (sum, row) => sum + row.due);
    setState(() {}); // Met à jour l'UI
  }

  @override
  void initState() {
    super.initState();
    _rc = Get.put(ReceiptController()); // << instanciation
    _rc.loadReceipts(); // << chargement initial
    // Subscribe à la liste pour reconstruire le grid automatiquement
    ever<List<Receipt>>(_rc.receipts, (_) => _initializeDataSource());

    _invoiceDataGridSource = InvoiceDataGridSource(rows);

    // charge initialement tous les reçus
    _rc.clearFilters();

    // Charge aussi la liste des agents
    Get.find<AgentController>().fetchAll();
  }

  void _initializeDataSource() {
    // Transforme chaque Receipt en InvoiceRow
    rows = _rc.receipts
        .map((r) => InvoiceRow(
              invoiceNo: r.receiptNumber,
              client: '${r.client.firstname} ${r.client.name}',
              amount: r.total,
              paid: r.paid,
              due: r.due,
            ))
        .toList();

    _invoiceDataGridSource = InvoiceDataGridSource(rows);
    setState(() {}); // relance le build pour rafraîchir le grid
  }

  void updateRows(List<InvoiceRow> newRows) {
    setState(() {
      rows = newRows;
      _invoiceDataGridSource = InvoiceDataGridSource(rows);
    });
  }

  Future<void> _showMonthlyIntervalDialog() async {
    DateTime? tempFrom = _rc.filterFrom.value;
    DateTime? tempTo = _rc.filterTo.value;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Sélectionner un intervalle de date'),
          content: StatefulBuilder(
            builder: (ctx, setSt) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Du
                  Row(
                    children: [
                      const Text('Du :'),
                      const SizedBox(width: 8),
                      Text(tempFrom != null
                          ? DateFormat.yMd().format(tempFrom!)
                          : '—'),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await showBoardDateTimePicker(
                            context: ctx,
                            pickerType: DateTimePickerType.date,
                            initialDate: tempFrom ?? DateTime.now(),
                            minimumDate: DateTime(2025),
                            maximumDate: DateTime(2045),
                          );
                          if (d != null) setSt(() => tempFrom = d);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Au
                  Row(
                    children: [
                      const Text('Au :'),
                      const SizedBox(width: 8),
                      Text(tempTo != null
                          ? DateFormat.yMd().format(tempTo!)
                          : '—'),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await showBoardDateTimePicker(
                            context: ctx,
                            pickerType: DateTimePickerType.date,
                            initialDate: tempTo ?? tempFrom ?? DateTime.now(),
                            minimumDate: tempFrom ?? DateTime(2025),
                            maximumDate: DateTime(2045),
                          );
                          if (d != null) setSt(() => tempTo = d);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tempFrom != null &&
                    tempTo != null &&
                    !tempTo!.isBefore(tempFrom!)) {
                  _rc.filterFrom.value = tempFrom;
                  _rc.filterTo.value = tempTo;
                  _rc.loadReceipts();
                  Navigator.of(ctx).pop();
                } else {
                  Get.snackbar(
                    'Erreur',
                    'Veuillez sélectionner un intervalle valide.',
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return /*Obx(() {*/
    Responsive.isMobile(context)
        ? SingleChildScrollView(
            child: Container(
              width: 380,
              // height: 950,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ✅ 1) Boutons GLOBAL, MENSUELLE, JOURNALIÈRE plus petits

                  Obx(() {
                    if (_rc.filterDate.value != null) {
                      final d = _rc.filterDate.value!;
                      return Text('Date : ${DateFormat.yMMMd().format(d)}');
                    } else if (_rc.filterFrom.value != null &&
                        _rc.filterTo.value != null) {
                      final f = _rc.filterFrom.value!, t = _rc.filterTo.value!;
                      return Text(
                          'Du : ${DateFormat.yMMMd().format(f)}  Au : ${DateFormat.yMMMd().format(t)}');
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        ['GLOBAL', 'MENSUELLE', 'JOURNALIÈRE'].map((label) {
                      final isActive = period == label;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              backgroundColor: isActive
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade200,
                              foregroundColor: isActive
                                  ? Colors.white
                                  : const Color(0xFF7717E8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              minimumSize: const Size(70, 30),
                            ),
                            onPressed: () async {
                              setState(() => period = label);

                              if (label == 'GLOBAL') {
                                // 1) Remise à zéro des filtres date
                                // _rc.filterDate.value = null;
                                // _rc.filterFrom.value = null;
                                // _rc.filterTo.value = null;
                                // await _rc.loadReceipts();
                                _rc
                                  ..filterDate.value = null
                                  ..filterFrom.value = null
                                  ..filterTo.value = null;
                                _rc.loadReceipts();
                              } else if (label == 'JOURNALIÈRE') {
                                // 2) Picker jour unique
                                // Remise à zéro des intervalles mensuels
                                _rc
                                  ..filterFrom.value = null
                                  ..filterTo.value = null;
                                final date = await showBoardDateTimePicker(
                                  context: context,
                                  pickerType:
                                      DateTimePickerType.date, // un seul jour
                                  initialDate: DateTime.now(),
                                  minimumDate: DateTime(2025),
                                  maximumDate: DateTime(2045),
                                );

                                if (date != null) {
                                  _rc.filterDate.value = date;
                                  // on vide intervalle
                                  _rc.filterFrom.value = null;
                                  _rc.filterTo.value = null;
                                  await _rc.loadReceipts();
                                }
                              } else /* MENSUELLE */ {
                                // 3) Picker intervalle de date
                                // Clear single-date filter
                                _rc.filterDate.value = null;
                                await _showMonthlyIntervalDialog();
                              }
                            },
                            child: Text(label,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),
                  const CustomDivider(),
                  const SizedBox(height: 20),

                  // ✅ 2) Inputs en colonne + Bouton de recherche en bas
                  Column(
                    children: [
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          value: (_rc.filterCashier.value?.isEmpty ?? true)
                            ? null
                            : _rc.filterCashier.value,

                          decoration: const InputDecoration(labelText: "Caissier"),
                          items: _rc.availableCashiers
                            .map((fullName) => DropdownMenuItem(
                              value: fullName,
                              child: Text(fullName),
                            ))
                            .toList(),
                          onChanged: (selected) {
                            _rc.filterCashier.value = selected ?? '';
                            _rc.loadReceipts();
                          },
                        );
                      }),

                      const SizedBox(height: 12),

                      // Produit
                      DropdownButtonFormField<String>(
                        value: _rc.filterProduct.value,
                        decoration: const InputDecoration(labelText: "Produit"),
                        items: _rc.availableProducts
                            .map((p) =>
                                DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) {
                          _rc.filterProduct.value = v;
                          _rc.loadReceipts();
                        },
                      ),

                      const SizedBox(height: 12),

                      // DropdownButtonFormField(
                      //   decoration: InputDecoration(labelText: "Statut"),
                      //   items: ["Payé", "Reste à payer"]
                      //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      //       .toList(),
                      //   onChanged: (value) {},
                      // ),
                      // Statut
                      DropdownButtonFormField<String>(
                        value: _rc.filterStatus.value,
                        decoration: const InputDecoration(labelText: "Statut"),
                        items: ['paid', 'due']
                            .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                    s == 'paid' ? 'Payé' : 'Reste à payer')))
                            .toList(),
                        onChanged: (v) {
                          _rc.filterStatus.value = v;
                          _rc.loadReceipts();
                        },
                      ),

                      const SizedBox(height: 16),

                      // ✅ Bouton de recherche aligné à droite
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.25, // 25% largeur écran
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 6, // Ajout d'une ombre
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Theme.of(context)
                                  .primaryColor, // Couleur primaire
                            ),
                            onPressed: () {
                              // Relance la recherche en tenant compte des dropdowns et de la période
                              _rc.loadReceipts();
                              print("Recherche");
                            },
                            child: const Icon(Icons.search,
                                color: Colors.white), // Icône blanche
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ✅ 3) Tableau ou état vide adapté à mobile
                  SizedBox(
                    height: 330, // Ajustement hauteur mobile
                    child: SingleChildScrollView(
                      scrollDirection: Axis
                          .horizontal, // 🔹 Active uniquement le scroll horizontal
                      child:  Obx(() {
                      if (_rc.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (_rc.receipts.isEmpty) {
                        return const Center(
                            child: Text('Aucune donnée trouvée !'));
                      }
                      return SfDataGrid(
                        columnWidthMode: ColumnWidthMode
                            .auto, // Permet aux colonnes de s'étendre dynamiquement
                        source: _invoiceDataGridSource,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'invoiceNo',
                            label: Container(
                              padding: const EdgeInsets.all(6),
                              alignment: Alignment.centerLeft,
                              child: const Text('N° de facture',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'client',
                            label: Container(
                              padding: const EdgeInsets.all(6),
                              alignment: Alignment.centerLeft,
                              child: const Text('Client',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'amount',
                            label: Container(
                              padding: const EdgeInsets.all(6),
                              alignment: Alignment.centerLeft,
                              child: const Text('Montant',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'paid',
                            label: Container(
                              padding: const EdgeInsets.all(6),
                              alignment: Alignment.centerLeft,
                              child: const Text('Payé',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          GridColumn(
                            columnName: 'due',
                            label: Container(
                              padding: const EdgeInsets.all(6),
                              alignment: Alignment.centerLeft,
                              child: const Text('Reste à payer',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      );
                    }
                  )
                  ),
                  )
                ],
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width * 0.55,
            height: 580,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // 1) Boutons GLOBAL, MENSUELLE, JOURNALIÈRE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['GLOBAL', 'MENSUELLE', 'JOURNALIÈRE'].map((label) {
                    final isActive = period == label;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: isActive
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade200,
                            foregroundColor:
                                isActive ? Colors.white : Color(0xFF7717E8),
                          ),
                          onPressed: () {
                            setState(() => period = label);
                            print("Filtre appliqué : $period");
                            // TODO: Recharger rows selon period
                          },
                          child: Text(label),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const CustomDivider(),
                const SizedBox(height: 30),

                // 2) Sélecteurs et recherche
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(labelText: "Caissier"),
                        items: ["Caissier 1", "Caissier 2", "Caissier 3"]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(labelText: "Produit"),
                        items: ["Produit A", "Produit B", "Produit C"]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(labelText: "Statut"),
                        items: ["Payé", "Reste à payer"]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                  ],
                ),
                const SizedBox(height: 30),

                // 3) Tableau ou état vide
                Container(
                    // color: Color.fromARGB(142, 121, 23, 232), // Pour voir l'espace pris
                    height: 320,
                    child: Obx(() {
                      if (_rc.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (_rc.receipts.isEmpty) {
                        return const Center(
                            child: Text('Aucune donnée trouvée !'));
                      }
                      return SfDataGrid(
                        columnWidthMode: ColumnWidthMode.fill,
                        source:
                            _invoiceDataGridSource, // La source modifiée avec la ligne TOTAL
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'invoiceNo',
                            label: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: const Text('N° de facture'),
                            ),
                          ),
                          GridColumn(
                            columnName: 'client',
                            label: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: const Text('Client'),
                            ),
                          ),
                          GridColumn(
                            columnName: 'amount',
                            label: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: const Text('Montant'),
                            ),
                          ),
                          GridColumn(
                            columnName: 'paid',
                            label: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: const Text('Payé'),
                            ),
                          ),
                          GridColumn(
                            columnName: 'due',
                            label: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.centerLeft,
                              child: const Text('Reste à payer'),
                            ),
                          ),
                        ],
                      );
                    }
                  )
                ),
              ],
            ));
    // });
  }
}

class InvoiceDataGridSource extends DataGridSource {
  InvoiceDataGridSource(this.invoiceRows) {
    buildDataGridRows();
  }

  final List<InvoiceRow> invoiceRows;
  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = invoiceRows.map<DataGridRow>((r) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'invoiceNo', value: r.invoiceNo),
        DataGridCell<String>(columnName: 'client', value: r.client),
        DataGridCell<double>(columnName: 'amount', value: r.amount),
        DataGridCell<double>(columnName: 'paid', value: r.paid),
        DataGridCell<double>(columnName: 'due', value: r.due),
      ]);
    }).toList();

    // Ajout de la ligne TOTAL en bas du tableau
    double totalAmount = invoiceRows.fold(0, (sum, row) => sum + row.amount);
    double totalPaid = invoiceRows.fold(0, (sum, row) => sum + row.paid);
    double totalDue = invoiceRows.fold(0, (sum, row) => sum + row.due);

    _dataGridRows.add(
      DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'invoiceNo',
            value: 'TOTAL'), // Fusion des colonnes N° + Client
        DataGridCell<String>(
            columnName: 'client', value: ''), // Vide pour fusionner
        DataGridCell<double>(columnName: 'amount', value: totalAmount),
        DataGridCell<double>(columnName: 'paid', value: totalPaid),
        DataGridCell<double>(columnName: 'due', value: totalDue),
      ]),
    );
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            cell.value.toString(),
            style: TextStyle(
              fontWeight: row.getCells()[0].value == 'TOTAL'
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Modèle de ligne de facture
class InvoiceRow {
  final String invoiceNo;
  final String client;
  final double amount;
  final double paid;
  final double due;

  InvoiceRow(
      {required this.invoiceNo,
      required this.client,
      required this.amount,
      required this.paid,
      required this.due});
}
