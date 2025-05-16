// import '../local/product_dao.dart';
// import '../local/invoice_dao.dart';
// import '../remote/product_api.dart';
// import '../remote/invoice_api.dart';
// import 'package:get_storage/get_storage.dart';

// class SyncManager {
//   final prodDao = ProductDao();
//   final invDao = InvoiceDao();
//   final prodApi = ProductApi();
//   final invApi = InvoiceApi();
//   final storage = GetStorage();

//   Future<void> syncAll() async {
//     final lastSync = DateTime.tryParse(storage.read('lastSync') ?? '') ?? DateTime(0);

//     // Push produits Sales
//     final dirtyProds = await prodDao.getDirtySince(lastSync);
//     if (dirtyProds.isNotEmpty) {
//       await prodApi.push(dirtyProds);
//       dirtyProds.forEach((p) => prodDao.clearDirtyFlag(p.id));
//     }

//     // Pull updates
//     final updatedProds = await prodApi.fetchUpdated(since: lastSync);
//     updatedProds.forEach((p) => prodDao.upsert(p));

//     // idem factures...

//     storage.write('lastSync', DateTime.now().toIso8601String());
//   }
// }