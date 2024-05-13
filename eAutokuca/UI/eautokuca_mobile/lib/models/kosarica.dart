import 'package:eautokuca_mobile/models/autodijelovi.dart';

class Kosarica {
  List<KosaricaItem> items = [];
  int? korisnikId;

  factory Kosarica() => Kosarica._();
  Kosarica._();

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
      "korisnikId": korisnikId,
    };
  }

  Kosarica.fromJson(Map<String, dynamic> json) {
    items = (json["items"] as List<dynamic>)
        .map((itemData) => KosaricaItem.fromJson(itemData))
        .toList();
    korisnikId = json["korisnikId"];
  }
}

class KosaricaItem {
  KosaricaItem(this.autodio, this.count);
  late Autodijelovi autodio;
  late int count;

  Map<String, dynamic> toJson() {
    return {
      "autodio": autodio.toJson(),
      "count": count,
    };
  }

  KosaricaItem.fromJson(Map<String, dynamic> json) {
    autodio = Autodijelovi.fromJson(json["autodio"]);
    count = json["count"] as int;
  }
}
