import 'package:get/get.dart';
import 'package:migo/models/servicemedical/servicemedical.dart';
import 'package:migo/service/servicemedical_service.dart';

class ServiceController extends GetxController {
  final ServiceServices _serviceService = Get.put(ServiceServices());

  var isLoading = false.obs;
  var serviceList = <Product>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAll();
  // }

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() => fetchAll()); // ✅ Exécute après le build
  }

  /// Charge tous les services
  // void fetchAll() async {
  //   isLoading(true);
  //   final res = await _serviceService.fetchAll();
  //   if (res != null) serviceList.value = res;
  //   isLoading(false);
  // }
  void fetchAll() async {
    isLoading.value = true; // ✅ Utilisation correcte
    final res = await _serviceService.fetchAll();
    if (res != null) serviceList.value = res;
    isLoading.value = false; // ✅ Assure la mise à jour propre
  }

  /// Filtre par catégorie
  void fetchByCategory(String cat) async {
    isLoading(true);
    final res = await _serviceService.fetchByCategory(cat);
    if (res != null) serviceList.value = res;
    isLoading(false);
  }

  /// Recherche sur tous les services
  void search(String term) async {
    isLoading(true);
    final res = await _serviceService.search(term);
    if (res != null) serviceList.value = res;
    isLoading(false);
  }

  /// ─── METTRE À JOUR UN SERVICE ───
  Future<bool> updateService(
      Product product, String newLabel, String newTarif) async {
    try {
      isLoading.value = true;
      // Constituer le payload JavaScript à envoyer
      final payload = {
        'label': newLabel,
        'tarif': newTarif,
        // Si vous avez d’autres champs (category, icon…), ajoutez-les ici
      };

      final success =
          await _serviceService.updateService(product.id.toString(), payload);
      print("Controller _serviceService.updateService :, $success");
      if (success) {
        // Mettre à jour localement la liste (optionnel)
        final index = serviceList.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          serviceList[index].label = newLabel;
          serviceList[index].tarif = newTarif;
          serviceList.refresh(); // Notifier l’UI que la liste a changé
        }
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
