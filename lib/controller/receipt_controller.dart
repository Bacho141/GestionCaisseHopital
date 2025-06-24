import 'package:get/get.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:migo/service/receipt_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:migo/utils/number_to_words_fr.dart';
import 'package:migo/models/authManager.dart';
import 'package:migo/models/receipt/client_patient.dart';
import 'package:migo/models/servicemedical/servicemedical.dart';
import 'package:migo/models/receipt/receipt_cart_model.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:intl/intl.dart';

class ReceiptController extends GetxController {
  final ReceiptService _receiptService = Get.put(ReceiptService());
  final AuthenticationManager _authMgr = Get.find();
  final AgentController _agentCtrl = Get.put(AgentController());

  // Panier en cours
  RxList<ReceiptItem> cart = <ReceiptItem>[].obs;
  Rxn<Receipt> currentReceipt = Rxn<Receipt>();
  RxBool isCreating = false.obs;

  // RxList<String> availableCashiers = <String>[].obs;
  RxnString selectedCashier = RxnString();


  // Liste des reçus et état
  var receipts = <Receipt>[].obs;
  var isLoading = false.obs;

  // Filtres
  var filterDate = Rxn<DateTime>();
  var filterFrom = Rxn<DateTime>();
  var filterTo = Rxn<DateTime>();
  var filterCashier = RxnString();
  var filterProduct = RxnString();
  var filterStatus = RxnString(); // 'paid' ou 'due'

  

  @override
  void onInit() {
    super.onInit();
    loadReceipts();
  }

  /// Initialise un nouveau reçu avec les infos de base
  void initNewReceipt({
    required String clientName,
    required String clientFirstname,
    required String clientPhone,
    required String clientAddress,
  }) async {
    // Génération du numéro : "REC-YYYYMMDDHHmmss"
    // final now = DateTime.now();
    // final timestamp = '${now.year.toString().padLeft(4, '0')}'
    //     '${now.month.toString().padLeft(2, '0')}'
    //     '${now.day.toString().padLeft(2, '0')}'
    //     '${now.hour.toString().padLeft(2, '0')}'
    //     '${now.minute.toString().padLeft(2, '0')}'
    //     '${now.second.toString().padLeft(2, '0')}';
    // final receiptNumber = 'REC-$timestamp';
    final now = DateTime.now();
    final timestamp =
        '${(now.year % 100)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    final receiptNumber = 'REC-$timestamp';

    // Récupération du nom du caissier depuis le token JWT
    // final token = _authCtrl.getToken();
    final token = await _authMgr.getToken();
    print('▶ initNewReceipt() – token récupéré : $token');
    // String nomCaissier = _authCtrl.userName.value;
    String nomCaissier = "Bachir";
    if (token != null && JwtDecoder.decode(token)['id'] != null) {
      nomCaissier = JwtDecoder.decode(token)['id'];
    }

    // Infos société en dur
    const companyName = 'Ma Société';
    const nif = 'NIF-123-456';
    const rccm = 'RCCM-2023-789';
    const address = '123 Rue Principale';
    const contact = '+22790000000';

    // Création du Receipt initial
    currentReceipt.value = Receipt(
      receiptNumber: receiptNumber,
      dateTime: now,
      client: Client(
        name: clientName,
        firstname: clientFirstname,
        phone: clientPhone,
        address: clientAddress,
      ),
      produits: [],
      total: 0,
      totalInWords: NumberToWordsFR.convert(0),
      paid: 0,
      due: 0,
      companyName: companyName,
      nif: nif,
      rccm: rccm,
      address: address,
      contact: contact,
      nomCaissier: nomCaissier,
    );
    // print("initNewReceipt : ${jsonEncode(currentReceipt.value?.toMap())}");
    print("""
    ────────────────────────────
    📜 Reçu généré :
    Numéro : ${currentReceipt.value!.receiptNumber}
    Date : ${currentReceipt.value!.dateTime}
    Client : ${currentReceipt.value!.client.name} ${currentReceipt.value!.client.firstname}
    Téléphone : ${currentReceipt.value!.client.phone}
    Adresse : ${currentReceipt.value!.client.address}
    Produits : ${currentReceipt.value!.produits}
    Total : ${currentReceipt.value!.total} F (${currentReceipt.value!.totalInWords})
    Payé : ${currentReceipt.value!.paid} F
    Dû : ${currentReceipt.value!.due} F
    Société : ${currentReceipt.value!.companyName}
    NIF : ${currentReceipt.value!.nif}
    RCCM : ${currentReceipt.value!.rccm}
    Adresse entreprise : ${currentReceipt.value!.address}
    Contact : ${currentReceipt.value!.contact}
    Caissier : ${currentReceipt.value!.nomCaissier}
    ────────────────────────────
    """);
    cart.clear();
  }

  /// Ajoute un service au panier et recalcul des totaux
  void addService(Product p, int quantity) {
    final amount = quantity * double.parse(p.tarif);
    cart.add(ReceiptItem(
      productId: p.id,
      label: p.label,
      tarif: double.parse(p.tarif),
      quantity: quantity,
      amount: amount,
    ));
    _recalculateTotals();
  }

  void _recalculateTotals() {
    final total = cart.fold<double>(0, (sum, i) => sum + i.amount);
    final paid = currentReceipt.value?.paid ?? 0;
    final due = total - paid;
    currentReceipt.update((r) {
      if (r != null) {
        r.produits = cart;
        r.total = total;
        r.totalInWords = NumberToWordsFR.convert(total.toInt());
        r.due = due;
      }
    });
  }

  Future<bool> createReceipt() async {
    if (currentReceipt.value == null) return false;
    isCreating.value = true;

    // 1) Construisez une Map manuelle qui inclut cart pour 'produits'
    final base = currentReceipt.value!.toMap();
    base['produits'] = cart.map((item) => item.toMap()).toList();

    // 2) Envoyez ce payload au service
    final id = await _receiptService.createReceipt(base);

    isCreating.value = false;
    if (id != null) {
      currentReceipt.value = await _receiptService.getReceipt(id);
      return true;
    }
    return false;
  }

  //Modification
  void updateClient(
      String firstname, String name, String phone, String address) {
    currentReceipt.update((r) {
      if (r != null) {
        r.client = Client(
          firstname: firstname,
          name: name,
          phone: phone,
          address: address,
        );
      }
    });
  }

  void updatePaid(double newPaid) {
    currentReceipt.update((r) {
      if (r != null) r.paid = newPaid;
    });
    _recalculateTotals();
  }

  //Modication d'un service
  void updateServiceQuantity(ReceiptItem item, int newQty) {
    final index = cart.indexOf(item);
    if (index != -1) {
      cart[index] = ReceiptItem(
        productId: item.productId,
        label: item.label,
        tarif: item.tarif,
        quantity: newQty,
        amount: newQty * item.tarif,
      );
      _recalculateTotals();
    }
  }

  void removeService(ReceiptItem item) {
    cart.remove(item);
    _recalculateTotals();
  }

  Future<void> _loadCashiers() async {
    // Assurez-vous que AgentController a déjà chargé ses agents
    if (_agentCtrl.agents.isEmpty) {
      await _agentCtrl.fetchAll();
    }
    // Concatène prénom + nom
    availableCashiers.assignAll(
      _agentCtrl.agents.map((a) => '${a.prenom} ${a.nom}'),
    );
  }

  List<String> get availableCashiers => 
  _agentCtrl.agents
    .map((a) => '${a.nom} ${a.prenom}')
    .toList();
  

  
  /// Liste de tous les produits (labels) uniques présents dans [receipts]
  List<String> get availableProducts {
    // on "aplatit" toutes les listes de produits, on prend leur label, on enlève les doublons
    return receipts
        .expand((r) => r.produits)
        .map((item) => item.label)
        .toSet()
        .toList();
  }


  Future<void> loadReceipts() async {
    final Map<String, String> params = {};

    // --- Périodes ---
    if (filterDate.value != null) {
      final d = filterDate.value!;
      params['from'] = params['to'] = DateFormat('yyyy-MM-dd').format(d);
    } else if (filterFrom.value != null && filterTo.value != null) {
      params['from'] = DateFormat('yyyy-MM-dd').format(filterFrom.value!);
      params['to']   = DateFormat('yyyy-MM-dd').format(filterTo.value!);
    }

    // --- Dropdowns ---
    if (filterCashier.value != null) params['cashier'] = filterCashier.value!;
    if (filterProduct.value  != null) params['product']  = filterProduct.value!;
    if (filterStatus.value   != null) params['status']   = filterStatus.value!;

    // **Debug print**
    print('▶ loadReceipts() – query params = $params');

    try {
      /**
       * 
      Une exception s'est produite.
FlutterError (setState() or markNeedsBuild() called during build.
This Obx widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
The widget on which setState() or markNeedsBuild() was called was:
  Obx
The widget which was currently being built when the offending call was made was:
  LayoutBuilder)
       */
      isLoading.value = true;
      final list = await _receiptService.fetchReceipts(params);
      receipts.assignAll(list ?? []);
    } finally {
      isLoading.value = false;
    }
  }


  /// Réinitialise tous les filtres
  void clearFilters() {
    filterDate.value = null;
    filterFrom.value = null;
    filterTo.value = null;
    filterCashier.value = null;
    filterProduct.value = null;
    filterStatus.value = null;
    loadReceipts();
  }

  /// Supprime un reçu et recharge
  Future<void> deleteReceipt(String id) async {
    final ok = await _receiptService.deleteReceipt(id);
    if (ok) {
      receipts.removeWhere((r) => r.receiptNumber == id);
    }
  }
}
