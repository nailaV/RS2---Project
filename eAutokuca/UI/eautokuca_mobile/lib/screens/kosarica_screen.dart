// ignore_for_file: unused_field, prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'package:eautokuca_mobile/models/kosarica.dart';
import 'package:eautokuca_mobile/providers/autodijelovi_provider.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/providers/kosarica_provider.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class KosaricaScreen extends StatefulWidget {
  const KosaricaScreen({super.key});

  @override
  State<KosaricaScreen> createState() => _KosaricaScreenState();
}

class _KosaricaScreenState extends State<KosaricaScreen> {
  late KosaricaProvider _kosaricaProvider;
  late KorisniciProvider _korisniciProvider;
  late AutodijeloviProvider _autodijeloviProvider;

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
                  onPressed: () {},
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
