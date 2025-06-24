import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart'
    as flutterpos;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:collection/collection.dart';
import 'package:migo/models/receipt/receipt_model.dart';

/// Type d’imprimante
enum ConnectionType { bluetooth, usb }

/// 1) Choix entre Bluetooth ou USB
Future<PrinterType?> showPrintOptions(BuildContext ctx) {
  return showDialog<PrinterType>(
    context: ctx,
    barrierDismissible: true,
    builder: (_) => AlertDialog(
      title: const Text('Mode d’impression'),
      content: const Text('Choisissez le type de connexion :'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, PrinterType.bluetooth),
          child: const Text('Bluetooth'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, PrinterType.usb),
          child: const Text('USB'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, null),
          child: const Text('Annuler'),
        ),
      ],
    ),
  );
}

/// 1. Scanne les imprimantes Bluetooth pendant [timeout].
///    Retourne la liste des PrinterDevice trouvés.
Future<List<PrinterDevice>> scanBluetoothPrinters({
  Duration timeout = const Duration(seconds: 5),
}) async {
  final List<PrinterDevice> devices = [];
  // Lance la découverte
  // final Stream<PrinterDevice> stream = PrinterManager.instance.discovery(
  //   type: PrinterType.bluetooth,
  // );
  final Stream<flutterpos.PrinterDevice> stream =
      PrinterManager.instance.discovery(
    type: PrinterType.bluetooth,
  );

  // Écoute les découvertes
  final sub = stream.listen((device) {
    debugPrint('🔍 Découvert Bluetooth → ${device.name} (${device.address})');
    // Évite les doublons
    if (!devices.any((d) => d.address == device.address)) {
      devices.add(device);
    }
  }, onError: (err) {
    debugPrint('❌ Erreur pendant le scan Bluetooth : $err');
  });

  // Attend la fin du timeout
  await Future.delayed(timeout);
  // Arrête l’écoute
  await sub.cancel();
  return devices;
}

/// 2. Affiche un dialog permettant de choisir l’imprimante Bluetooth.
///    Renvoie le PrinterDevice ou null si l’utilisateur annule.
Future<PrinterDevice?> showBluetoothPrinterDialog(BuildContext ctx) async {
  // 2.1) Lance le scan
  final devices = await scanBluetoothPrinters();

  // 2.2) Affiche le dialog
  return showDialog<PrinterDevice>(
    context: ctx,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sélection Bluetooth'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: devices.isEmpty
              ? const Center(child: Text('Aucune imprimante trouvée'))
              : ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (_, i) {
                    final d = devices[i];
                    return ListTile(
                      title: Text(d.name ?? 'Inconnu'),
                      subtitle: Text(d.address ?? ''),
                      onTap: () => Navigator.of(context).pop(d),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Annuler'),
          ),
        ],
      );
    },
  );
}

/// 3. Scanne les imprimantes USB pendant [timeout].
///    Retourne la liste des PrinterDevice trouvés.
Future<List<PrinterDevice>> scanUsbPrinters({
  Duration timeout = const Duration(seconds: 5),
}) async {
  final List<PrinterDevice> devices = [];
  // Lance la découverte USB
  final Stream<PrinterDevice> stream = PrinterManager.instance.discovery(
    type: PrinterType.usb,
  );
  final sub = stream.listen((device) {
    debugPrint('🔍 Découvert USB → ${device.name} (${device.address})');
    if (!devices.any((d) => d.address == device.address)) {
      print("Découvert USB");
      devices.add(device);
    }
  }, onError: (err) {
    debugPrint('❌ Erreur pendant le scan USB : $err');
  });

  // Attend la fin du timeout
  await Future.delayed(timeout);
  await sub.cancel();
  return devices;
}

/// 4. Affiche un dialog permettant de choisir l’imprimante USB.
///    Renvoie le PrinterDevice ou null si l’utilisateur annule.
Future<PrinterDevice?> showUsbPrinterDialog(BuildContext ctx) async {
  // 4.1) Lance le scan USB
  final devices = await scanUsbPrinters();

  // 4.2) Affiche le dialog
  return showDialog<PrinterDevice>(
    context: ctx,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sélection USB'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: devices.isEmpty
              ? const Center(child: Text('Aucune imprimante USB trouvée'))
              : ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (_, i) {
                    final d = devices[i];
                    return ListTile(
                      title: Text(d.name ?? 'Inconnu'),
                      subtitle: Text(d.address ?? ''),
                      onTap: () => Navigator.of(context).pop(d),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Annuler'),
          ),
        ],
      );
    },
  );
}

/// 2) Modèle minimal de Ticket
class Ticket {
  final List<int> bytes;
  Ticket(this.bytes);
}

/// 3) File d’impression en FIFO
class PrintQueue {
  PrintQueue._private();
  static final PrintQueue instance = PrintQueue._private();

  final QueueList<Ticket> _queue = QueueList<Ticket>();
  bool _processing = false;

  /// Enqueue un ticket et lance le worker si besoin
  void enqueue(
    Ticket ticket, {
    required Future<void> Function(Ticket) printerFunc,
    required void Function(String) onError,
  }) {
    _queue.add(ticket);
    if (!_processing) _processNext(printerFunc, onError);
  }

  /// Worker
  Future<void> _processNext(
    Future<void> Function(Ticket) printerFunc,
    void Function(String) onError,
  ) async {
    if (_queue.isEmpty) {
      _processing = false;
      return;
    }
    _processing = true;
    final ticket = _queue.removeFirst();
    try {
      await printerFunc(ticket);
    } catch (e) {
      onError(e.toString());
    } finally {
      // Passe au suivant
      _processNext(printerFunc, onError);
    }
  }
}

///  ––––––––––––––––––––––––––––––––––––––––––––
/// Méthode unique à appeler depuis votre `onPressed`
///  ––––––––––––––––––––––––––––––––––––––––––––

Future<void> handlePrintReceipt(BuildContext context, Receipt receipt) async {
  // 1) Choix du type
  final mode = await showPrintOptions(context);
  if (mode == null) return;

  // 2) Sélection de l’imprimante
  PrinterDevice? device = (mode == PrinterType.bluetooth)
      ? await showBluetoothPrinterDialog(context)
      : await showUsbPrinterDialog(context);
  if (device == null) return;

  // 3) Génération du ticket ESC/POS
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  var bytes = <int>[];
  bytes += generator.text(
    receipt.companyName,
    styles: const PosStyles(align: PosAlign.center, bold: true),
  );
  // … autres lignes …
  bytes += generator.cut();
  final ticket = Ticket(bytes);

  // 4) Enqueue + impression
  PrintQueue.instance.enqueue(
    ticket,
    printerFunc: (t) async {
      // a) Connexion
      await PrinterManager.instance.connect(
        type: mode,
        model: mode == PrinterType.bluetooth
            ? BluetoothPrinterInput(
                name: device.name!,
                address: device.address!,
                isBle: device.isBlank ?? false,
              )
            : UsbPrinterInput(
                name: device.name,
                vendorId: device.vendorId,
                productId: device.productId,
              ),
      );
      // b) Envoi des octets
      await PrinterManager.instance.send(
        type: mode,
        bytes: t.bytes,
      );
      // c) Déconnexion
      await PrinterManager.instance.disconnect(
        type: mode,
      );
    },
    onError: (msg) {
      Get.snackbar(
        'Erreur impression',
        msg,
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
    },
  );

  print("Votre ticket a été ajouté à la file d’impression.");

  // 5) Feedback
  Get.snackbar(
    'Impression',
    'Votre ticket a été ajouté à la file d’impression.',
    snackPosition: SnackPosition.BOTTOM,
  );
}
