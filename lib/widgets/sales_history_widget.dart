import 'package:flutter/material.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:migo/view/responsive.dart';

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
  List<InvoiceRow> rows = [
    InvoiceRow(invoiceNo: "INV001", client: "Client AClientClient AA", amount: 1500.0, paid: 1200.0, due: 300.0),
    InvoiceRow(invoiceNo: "INV002", client: "Client B", amount: 2400.0, paid: 2400.0, due: 0.0),
    InvoiceRow(invoiceNo: "INV003", client: "Client C", amount: 3200.0, paid: 2500.0, due: 700.0),
    InvoiceRow(invoiceNo: "INV004", client: "Client D", amount: 900.0, paid: 500.0, due: 400.0),
    InvoiceRow(invoiceNo: "INV005", client: "Client E", amount: 1850.0, paid: 1850.0, due: 0.0),
    InvoiceRow(invoiceNo: "INV006", client: "Client F", amount: 4100.0, paid: 4000.0, due: 100.0),
    InvoiceRow(invoiceNo: "INV007", client: "Client A", amount: 1500.0, paid: 1200.0, due: 300.0),
    InvoiceRow(invoiceNo: "INV002", client: "Client B", amount: 2400.0, paid: 2400.0, due: 0.0),
    InvoiceRow(invoiceNo: "INV003", client: "Client C", amount: 3200.0, paid: 2500.0, due: 700.0),
    InvoiceRow(invoiceNo: "INV004", client: "Client D", amount: 900.0, paid: 500.0, due: 400.0),
    InvoiceRow(invoiceNo: "INV005", client: "Client E", amount: 1850.0, paid: 1850.0, due: 0.0),
    InvoiceRow(invoiceNo: "INV006", client: "Client F", amount: 4100.0, paid: 4000.0, due: 100.0),
  ]; // Chargé par ton DataGridSource
  late InvoiceDataGridSource _invoiceDataGridSource;

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
    _invoiceDataGridSource = InvoiceDataGridSource(rows);
  }

  void updateRows(List<InvoiceRow> newRows) {
    setState(() {
      rows = newRows;
      _invoiceDataGridSource = InvoiceDataGridSource(rows);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context) 
      ? SingleChildScrollView(
        child: Container(
          width: 380, 
          // height: 750,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['GLOBAL', 'MENSUELLE', 'JOURNALIÈRE'].map((label) {
                  final isActive = period == label;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          backgroundColor: isActive
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade200,
                          foregroundColor: isActive ? Colors.white : Color(0xFF7717E8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          minimumSize: const Size(70, 30), // Boutons plus petits
                        ),
                        onPressed: () {
                          setState(() => period = label);
                          print("Filtre appliqué : $period");
                        },
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Caissier"),
                    items: ["Caissier 1", "Caissier 2", "Caissier 3"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Produit"),
                    items: ["Produit A", "Produit B", "Produit C"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Statut"),
                    items: ["Payé", "Reste à payer"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  
                  // ✅ Bouton de recherche aligné à droite
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25, // 25% largeur écran
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 6, // Ajout d'une ombre
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Theme.of(context).primaryColor, // Couleur primaire
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.search, color: Colors.white), // Icône blanche
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
                  scrollDirection: Axis.horizontal, // 🔹 Active uniquement le scroll horizontal
                  child: SfDataGrid(
                    columnWidthMode: ColumnWidthMode.auto, // Permet aux colonnes de s'étendre dynamiquement
                    source: _invoiceDataGridSource,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'invoiceNo',
                        label: Container(
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: const Text('N° de facture', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'client',
                        label: Container(
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: const Text('Client', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'amount',
                        label: Container(
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: const Text('Montant', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'paid',
                        label: Container(
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: const Text('Payé', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'due',
                        label: Container(
                          padding: const EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: const Text('Reste à payer', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
    ) : Container(
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
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 16),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          ),
          const SizedBox(height: 30),

          // 3) Tableau ou état vide
          Container(
            // color: Color.fromARGB(142, 121, 23, 232), // Pour voir l'espace pris
            height: 320,
            child: rows.isEmpty
              ? Center(
                  child: Text(
                    'Aucune donnée trouvée !',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : SfDataGrid(
                  columnWidthMode: ColumnWidthMode.fill,
                  source: _invoiceDataGridSource, // La source modifiée avec la ligne TOTAL
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
                )
          ),
        ],
      ),
    );
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
        DataGridCell<String>(columnName: 'invoiceNo', value: 'TOTAL'), // Fusion des colonnes N° + Client
        DataGridCell<String>(columnName: 'client', value: ''), // Vide pour fusionner
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
              fontWeight: row.getCells()[0].value == 'TOTAL' ? FontWeight.bold : FontWeight.normal,
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
