// ignore_for_file: unused_local_variable

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/models/kosarica.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KosaricaProvider with ChangeNotifier {
  Kosarica kosarica = Kosarica();

  double _total = 0.0;
  double get total => _total;
  set total(double total) {
    _total = total;
    notifyListeners();
  }

  dodajUkosaricu(Autodijelovi autodio, BuildContext context) {
    KosaricaItem? existingItem = findInKosarica(autodio);

    if (existingItem != null) {
      if (existingItem.count < autodio.kolicinaNaStanju!) {
        existingItem.count++;
      } else {
        _showSnackBar(
            context, "Nije moguće dodati veću količinu nego na stanju.");
      }
    } else {
      if (autodio.kolicinaNaStanju! > 0) {
        kosarica.items.add(KosaricaItem(autodio, 1));
      } else {
        _showSnackBar(context, "Proizvod nije na stanju.");
      }
    }

    izracunajTotal();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  izbaciIzKosarice(Autodijelovi autodio) {
    kosarica.items
        .removeWhere((item) => item.autodio.autodioId == autodio.autodioId);
    izracunajTotal();
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
    }
  }

  izracunajTotal() {
    double total = 0.0;
    for (var item in kosarica.items) {
      total += item.count * (item.autodio.cijena ?? 0.0);
    }
    this.total = total;
  }
}
