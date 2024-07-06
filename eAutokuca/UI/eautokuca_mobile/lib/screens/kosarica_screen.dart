// ignore_for_file: unused_field, prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, unused_import

import 'dart:convert';

import 'package:eautokuca_mobile/models/kosarica.dart';
import 'package:eautokuca_mobile/providers/autodijelovi_provider.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/providers/kosarica_provider.dart';
import 'package:eautokuca_mobile/providers/narudzba_provider.dart';
import 'package:eautokuca_mobile/stripeKeys.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as sp;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class KosaricaScreen extends StatefulWidget {
  const KosaricaScreen({super.key});

  @override
  State<KosaricaScreen> createState() => _KosaricaScreenState();
}

class _KosaricaScreenState extends State<KosaricaScreen> {
  late KosaricaProvider _kosaricaProvider;
  late KorisniciProvider _korisniciProvider;
  late AutodijeloviProvider _autodijeloviProvider;
  late NarudzbaProvider _narudzbaProvider;
  int userId = 0;
  bool isLoading = true;
  int iznos = 0;
  Map<String, dynamic>? paymentIntent;
  List<KosaricaItem> proizvodi = [];
  String secretKey =
      const String.fromEnvironment("secretKey", defaultValue: secKey);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _kosaricaProvider = context.watch<KosaricaProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _autodijeloviProvider = context.read<AutodijeloviProvider>();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    getUserId();
  }

  Future<void> getUserId() async {
    try {
      var korisnikId = await _korisniciProvider.getKorisnikID();
      setState(() {
        userId = korisnikId;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Košarica",
      child: Column(
        children: [
          Expanded(
            child: _kosaricaProvider.kosarica.items.isNotEmpty
                ? _buildProductCardList()
                : _buildNoDataField(),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "UKUPNO: ${_kosaricaProvider.total.toStringAsFixed(2)} KM",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  color: Colors.yellow[700],
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await makePayment();
                  },
                  child: Text(
                    "Kupi",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  int calculateAmount() {
    return iznos = (_kosaricaProvider.total.toInt() * 100);
  }

  Future<Map<String, dynamic>> makePaymentIntent() async {
    final body = {
      'amount': calculateAmount().toString(),
      'currency': 'USD',
      'payment_method_types[]': 'card',
    };

    final headers = {
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: headers,
      body: body,
    );

    return jsonDecode(response.body);
  }

  Future<void> displayPaymentSheet() async {
    try {
      await sp.Stripe.instance.presentPaymentSheet();
      await saveData();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        padding: const EdgeInsets.all(15),
        content: const Text(
          "Transakcija otkazana",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await makePaymentIntent();
      await sp.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: sp.SetupPaymentSheetParameters(
          merchantDisplayName: 'Prodaja autodijelova',
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget _buildProductCardList() {
    return ListView.builder(
      itemCount: _kosaricaProvider.kosarica.items.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_kosaricaProvider.kosarica.items[index]);
      },
    );
  }

  Widget _buildProductCard(KosaricaItem item) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageFromBase64String(item.autodio.slika!),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.autodio.naziv ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${item.autodio.cijena.toString()} €',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    _kosaricaProvider.smanjiKolicinu(item.autodio);
                  },
                ),
                Text(item.count.toString(), style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _kosaricaProvider.dodajUkosaricu(item.autodio, context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.highlight_remove, color: Colors.red),
                  onPressed: () {
                    MyDialogs.showQuestion(
                        context, "Želite izbaciti proizvod iz košarice?", () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KosaricaScreen(),
                      ));
                      _kosaricaProvider.izbaciIzKosarice(item.autodio);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveData() async {
    try {
      Map<String, dynamic> transaction = {
        'brojTransakcije': paymentIntent!['id'],
        'ukupniIznos': _kosaricaProvider.total,
        'autodioId': 3,
        'kolicina': 1,
        'korisnikId': userId
      };

      await _narudzbaProvider.dodajNarudzbu(transaction);
      setState(() {
        isLoading = false;
        _kosaricaProvider.kosarica.items = [];
        _kosaricaProvider.total = 0;
      });
      MyDialogs.showSuccess(context, 'Uspješna transakcija.', () {
        Navigator.of(context).pop();
        setState(() {
          isLoading = true;
        });
        _kosaricaProvider.kosarica.items.isNotEmpty
            ? _buildProductCardList()
            : _buildNoDataField();
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Padding _buildNoDataField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 200),
          padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
            color: Colors.blueGrey[50],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.remove_shopping_cart),
              SizedBox(
                height: 10,
              ),
              Text(
                "Košarica je prazna",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
