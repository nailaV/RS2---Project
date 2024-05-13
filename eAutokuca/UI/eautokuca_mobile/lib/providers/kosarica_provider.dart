// ignore_for_file: unused_local_variable

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/models/kosarica.dart';
import 'package:flutter/cupertino.dart';

class KosaricaProvider with ChangeNotifier {
  Kosarica kosarica = Kosarica();

  set total(double total) {}

  dodajUkosaricu(Autodijelovi autodio) {
    KosaricaItem? existingItem = findInKosarica(autodio);

    if (existingItem != null) {
      existingItem.count++;
    } else {
      kosarica.items.add(KosaricaItem(autodio, 1));
    }

    izracunajTotal();
    notifyListeners();
  }

  izbaciIzKosarice(Autodijelovi autodio) {
    kosarica.items
        .removeWhere((item) => item.autodio.autodioId == autodio.autodioId);
    notifyListeners();
  }

  KosaricaItem? findInKosarica(Autodijelovi autodio) {
    for (var item in kosarica.items) {
      if (item.autodio.autodioId == autodio.autodioId) {
        return item;
      }
    }

    return null;
  }

  smanjiKolicinu(Autodijelovi autodio) {
    final postojeci = findInKosarica(autodio);
    if (postojeci != null) {
      postojeci.count = postojeci.count == 1 ? 1 : postojeci.count - 1;

      if (postojeci.count > autodio.kolicinaNaStanju!) {
        postojeci.count = autodio.kolicinaNaStanju!;
      }

      izracunajTotal();
      notifyListeners();
    }
  }

  izracunajTotal() {
    var total = 0.0;
    for (var item in kosarica.items) {
      total += item.count * (item.autodio.cijena ?? 0.0);
    }
    this.total = total;
  }
}
