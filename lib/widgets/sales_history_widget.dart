import 'package:flutter/material.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:migo/view/responsive.dart';
import 'package:get/get.dart';
import 'package:migo/controller/receipt_controller.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:migo/models/authManager.dart';
import 'package:migo/widgets/receipt_detail_modal.dart';

class SalesHistoryWidget extends StatefulWidget {
  const SalesHistoryWidget({Key? key}) : super(key: key);

  @override
  State<SalesHistoryWidget> createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryWidget> {
  // Variables d'état pour les filtres
  String period = 'GLOBAL';
  String? selectedCashier;
  String? selectedProduct;
  String? selectedStatus;

  List<InvoiceRow> rows = [];
  late InvoiceDataGridSource _invoiceDataGridSource;

  late final ReceiptController _rc;
  late final AuthController _authCtrl;
  final AuthenticationManager _authMgr = Get.find<AuthenticationManager>();

  // Variables pour l'agent connecté
  String? _connectedAgentId;
  bool _isAgent = false;

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
    _authCtrl = Get.find<AuthController>();

    // Subscribe à la liste pour reconstruire le grid automatiquement
    ever<List<Receipt>>(_rc.receipts, (_) => _initializeDataSource());

    _invoiceDataGridSource = InvoiceDataGridSource(rows, _rc.receipts);

    // Charge aussi la liste des agents
    Get.find<AgentController>().fetchAll();

    // Récupérer l'identité de l'agent connecté ET charger les reçus
    _initializeAgentIdentity();
  }

  /// Initialise l'identité de l'agent connecté et charge les reçus
  Future<void> _initializeAgentIdentity() async {
    print('🔄 _initializeAgentIdentity appelé');
    final token = await _authMgr.getToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decoded = JwtDecoder.decode(token);
      _connectedAgentId = decoded['id'] as String?;
      _isAgent = _authCtrl.userRole.value == 'Agent';

      print('👤 Informations de l\'utilisateur:');
      print('   - ID: $_connectedAgentId');
      print('   - Rôle: ${_authCtrl.userRole.value}');
      print('   - Est agent: $_isAgent');
      print('   - Nom complet: ${decoded['nomComplet']}');

      // Si c'est un agent, filtrer automatiquement ses reçus
      if (_isAgent && _connectedAgentId != null) {
        // Utiliser le nom complet pour le filtrage si disponible
        final nomComplet = decoded['nomComplet'] as String?;
        final filterValue = nomComplet ?? _connectedAgentId;
        print('🔍 Application du filtre agent: $filterValue');
        _rc.filterCashier.value = filterValue;
        await _rc.loadReceipts(); // Charger les reçus filtrés
      } else {
        print('👑 Chargement de tous les reçus (admin ou autre rôle)');
        // Pour les admins ou autres rôles, charger tous les reçus
        await _rc.loadReceipts();
      }
    } else {
      print('⚠️ Pas de token valide, chargement de tous les reçus');
      // Pas de token valide, charger tous les reçus
      await _rc.loadReceipts();
    }
  }

  void _initializeDataSource() {
    print('🔄 Initialisation de la source de données');
    print('📊 Nombre de reçus: ${_rc.receipts.length}');

    // Afficher l'ordre des reçus
    print('📋 Ordre des reçus dans _rc.receipts:');
    for (int i = 0; i < _rc.receipts.length; i++) {
      print(
          '   $i: ${_rc.receipts[i].receiptNumber} - ${_rc.receipts[i].client.firstname} ${_rc.receipts[i].client.name}');
    }

    // Transforme chaque Receipt en InvoiceRow
    rows = _rc.receipts.map((r) {
      print('📋 Transformation du reçu: ${r.receiptNumber}');
      print('   - Client: ${r.client.firstname} ${r.client.name}');
      print('   - Total: ${r.total}');
      print('   - Paid: ${r.paid}');
      print('   - Due: ${r.due}');

      return InvoiceRow(
        invoiceNo: r.receiptNumber,
        client: '${r.client.firstname} ${r.client.name}',
        amount: r.total,
        paid: r.paid,
        due: r.due,
      );
    }).toList();

    print('✅ Nombre de lignes créées: ${rows.length}');
    print('📋 Liste des numéros de reçus dans rows:');
    for (int i = 0; i < rows.length; i++) {
      print('   $i: ${rows[i].invoiceNo} - ${rows[i].client}');
    }

    _invoiceDataGridSource = InvoiceDataGridSource(rows, _rc.receipts);

    setState(() {}); // relance le build pour rafraîchir le grid
  }

  void updateRows(List<InvoiceRow> newRows) {
    setState(() {
      rows = newRows;
      _invoiceDataGridSource = InvoiceDataGridSource(rows, _rc.receipts);
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

  void _showReceiptDetail(Receipt receipt) {
    print('🔄 _showReceiptDetail appelé');
    print('🔄 Affichage du détail pour le reçu: ${receipt.receiptNumber}');
    print('📊 Données du reçu:');
    print('   - Total: ${receipt.total}');
    print('   - Paid: ${receipt.paid}');
    print('   - Due: ${receipt.due}');
    print('   - Client: ${receipt.client.firstname} ${receipt.client.name}');
    print('   - Produits: ${receipt.produits.length}');

    // Vérification de la validité du reçu
    if (receipt == null) {
      print('❌ Erreur: Tentative d\'affichage d\'un reçu null');
      Get.snackbar(
        'Erreur',
        'Impossible d\'afficher les détails du reçu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    print('📱 Affichage du modal...');
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche la fermeture en cliquant à l'extérieur
      builder: (BuildContext context) {
        print('🔨 Builder du modal appelé');
        return ReceiptDetailModal(
          receipt: receipt,
          onStatusChanged: () {
            print(
                '🔄 Rafraîchissement de la liste après modification du statut');
            // Rafraîchir la liste après modification du statut
            _rc.loadReceipts();
          },
        );
      },
    ).then((value) {
      print('✅ Modal fermé avec valeur: $value');
    }).catchError((error) {
      print('❌ Erreur lors de l\'affichage du modal: $error');
    });

    print('📱 showDialog appelé');
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
                          final f = _rc.filterFrom.value!,
                              t = _rc.filterTo.value!;
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
                                      pickerType: DateTimePickerType
                                          .date, // un seul jour
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
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
                          // Afficher le filtre Caissier seulement si ce n'est pas un agent
                          Obx(() {
                            // Masquer le filtre caissier pour les agents
                            if (_authCtrl.userRole.value == 'Agent') {
                              return const SizedBox.shrink();
                            }

                            return DropdownButtonFormField<String>(
                              value: (_rc.filterCashier.value?.isEmpty ?? true)
                                  ? null
                                  : _rc.filterCashier.value,
                              decoration:
                                  const InputDecoration(labelText: "Caissier"),
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
                            decoration:
                                const InputDecoration(labelText: "Produit"),
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

                          // Statut
                          DropdownButtonFormField<String>(
                            value: _rc.filterStatus.value,
                            decoration:
                                const InputDecoration(labelText: "Statut"),
                            items: ['paid', 'due']
                                .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s == 'paid'
                                        ? 'Payé'
                                        : 'Reste à payer')))
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
                            child: Obx(() {
                              if (_rc.isLoading.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (_rc.receipts.isEmpty) {
                                return Center(
                                    child: Text(
                                        _authCtrl.userRole.value == 'Agent'
                                            ? 'Aucun reçu pour cet agent.'
                                            : 'Aucune donnée trouvée !'));
                              }
                              return SfDataGrid(
                                columnWidthMode: ColumnWidthMode
                                    .auto, // Permet aux colonnes de s'étendre dynamiquement
                                source: _invoiceDataGridSource,
                                onCellTap: (DataGridCellTapDetails details) {
                                  print(
                                      '👆 Cell tap détecté sur: ${details.rowColumnIndex.rowIndex}');
                                  print(
                                      '📊 Nombre de reçus: ${_rc.receipts.length}');
                                  print(
                                      '📊 Nombre de lignes invoiceRows: ${rows.length}');

                                  // Ignorer les clics sur l'en-tête (index 0)
                                  if (details.rowColumnIndex.rowIndex == 0) {
                                    print('ℹ️ Clic sur l\'en-tête, ignoré');
                                    return;
                                  }

                                  // Vérifier que ce n'est pas la ligne TOTAL
                                  if (details.rowColumnIndex.rowIndex >=
                                      _rc.receipts.length + 1) {
                                    // +1 car on a ignoré l'en-tête
                                    print('ℹ️ Clic sur la ligne TOTAL, ignoré');
                                    return;
                                  }

                                  try {
                                    // Ajuster l'index pour correspondre aux reçus (soustraire 1 pour l'en-tête)
                                    final adjustedIndex =
                                        details.rowColumnIndex.rowIndex - 1;

                                    // Récupérer le numéro de reçu de la ligne cliquée
                                    final clickedRow = rows[adjustedIndex];
                                    final receiptNumber = clickedRow.invoiceNo;

                                    print(
                                        '📋 Index cliqué: ${details.rowColumnIndex.rowIndex}');
                                    print('📋 Index ajusté: $adjustedIndex');
                                    print(
                                        '📋 Numéro de reçu de la ligne: $receiptNumber');

                                    // Trouver le reçu correspondant par numéro de reçu
                                    final receipt = _rc.receipts.firstWhere(
                                      (r) => r.receiptNumber == receiptNumber,
                                      orElse: () {
                                        print(
                                            '❌ Reçu non trouvé pour: $receiptNumber');
                                        throw Exception(
                                            'Reçu non trouvé: $receiptNumber');
                                      },
                                    );

                                    print(
                                        '📋 Reçu trouvé: ${receipt.receiptNumber}');
                                    print(
                                        '📋 Client: ${receipt.client.firstname} ${receipt.client.name}');

                                    _showReceiptDetail(receipt);
                                  } catch (e) {
                                    print(
                                        '❌ Erreur lors de la sélection du reçu: $e');
                                    Get.snackbar(
                                      'Erreur',
                                      'Impossible de sélectionner le reçu',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  }
                                },
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
                            })),
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
                    Obx(() {
                      if (_rc.filterDate.value != null) {
                        final d = _rc.filterDate.value!;
                        return Text('Date : ${DateFormat.yMMMd().format(d)}');
                      } else if (_rc.filterFrom.value != null &&
                          _rc.filterTo.value != null) {
                        final f = _rc.filterFrom.value!,
                            t = _rc.filterTo.value!;
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
                        // Afficher le filtre Caissier seulement si ce n'est pas un agent
                        Obx(() {
                          // Masquer le filtre caissier pour les agents
                          if (_authCtrl.userRole.value == 'Agent') {
                            return const SizedBox.shrink();
                          }

                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: DropdownButtonFormField<String>(
                              value: (_rc.filterCashier.value?.isEmpty ?? true)
                                  ? null
                                  : _rc.filterCashier.value,
                              decoration:
                                  const InputDecoration(labelText: "Caissier"),
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
                            ),
                          );
                        }),
                        const SizedBox(width: 12),

                        // Produit
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Obx(() => TextFormField(
                                initialValue: _rc.filterProduct.value,
                                decoration: const InputDecoration(
                                    labelText: "Services"),
                                onChanged: (val) {
                                  _rc.filterProduct.value = val.trim();
                                  _rc.loadReceipts();
                                },
                              )),
                        ),

                        const SizedBox(width: 12),

                        // Statut
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Obx(() => DropdownButtonFormField<String>(
                                value: _rc.filterStatus.value,
                                decoration:
                                    const InputDecoration(labelText: "Statut"),
                                items: ['paid', 'due']
                                    .map((s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s == 'paid'
                                              ? 'Payé'
                                              : 'Reste à payer'),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  _rc.filterStatus.value = v ?? '';
                                  _rc.loadReceipts();
                                },
                              )),
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
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (_rc.receipts.isEmpty) {
                            return Center(
                                child: Text(_authCtrl.userRole.value == 'Agent'
                                    ? 'Aucun reçu pour cet agent.'
                                    : 'Aucune donnée trouvée !'));
                          }
                          return SfDataGrid(
                            columnWidthMode: ColumnWidthMode.fill,
                            source: _invoiceDataGridSource,
                            onCellTap: (DataGridCellTapDetails details) {
                              print(
                                  '👆 Cell tap détecté sur: ${details.rowColumnIndex.rowIndex}');
                              print(
                                  '📊 Nombre de reçus: ${_rc.receipts.length}');
                              print(
                                  '📊 Nombre de lignes invoiceRows: ${rows.length}');

                              // Ignorer les clics sur l'en-tête (index 0)
                              if (details.rowColumnIndex.rowIndex == 0) {
                                print('ℹ️ Clic sur l\'en-tête, ignoré');
                                return;
                              }

                              // Vérifier que ce n'est pas la ligne TOTAL
                              if (details.rowColumnIndex.rowIndex >=
                                  _rc.receipts.length + 1) {
                                // +1 car on a ignoré l'en-tête
                                print('ℹ️ Clic sur la ligne TOTAL, ignoré');
                                return;
                              }

                              try {
                                // Ajuster l'index pour correspondre aux reçus (soustraire 1 pour l'en-tête)
                                final adjustedIndex =
                                    details.rowColumnIndex.rowIndex - 1;

                                // Récupérer le numéro de reçu de la ligne cliquée
                                final clickedRow = rows[adjustedIndex];
                                final receiptNumber = clickedRow.invoiceNo;

                                print(
                                    '📋 Index cliqué: ${details.rowColumnIndex.rowIndex}');
                                print('📋 Index ajusté: $adjustedIndex');
                                print(
                                    '📋 Numéro de reçu de la ligne: $receiptNumber');

                                // Trouver le reçu correspondant par numéro de reçu
                                final receipt = _rc.receipts.firstWhere(
                                  (r) => r.receiptNumber == receiptNumber,
                                  orElse: () {
                                    print(
                                        '❌ Reçu non trouvé pour: $receiptNumber');
                                    throw Exception(
                                        'Reçu non trouvé: $receiptNumber');
                                  },
                                );

                                print(
                                    '📋 Reçu trouvé: ${receipt.receiptNumber}');
                                print(
                                    '📋 Client: ${receipt.client.firstname} ${receipt.client.name}');

                                _showReceiptDetail(receipt);
                              } catch (e) {
                                print(
                                    '❌ Erreur lors de la sélection du reçu: $e');
                                Get.snackbar(
                                  'Erreur',
                                  'Impossible de sélectionner le reçu',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            },
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
                        })),
                  ],
                ));
    // });
  }
}

class InvoiceDataGridSource extends DataGridSource {
  InvoiceDataGridSource(this.invoiceRows, this.receipts) {
    buildDataGridRows();
  }

  final List<InvoiceRow> invoiceRows;
  final List<Receipt> receipts;
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
    final isTotalRow = row.getCells()[0].value == 'TOTAL';

    print(
        '🔍 buildRow appelé pour: ${row.getCells()[0].value} (isTotalRow: $isTotalRow)');

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            cell.value.toString(),
            style: TextStyle(
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
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
