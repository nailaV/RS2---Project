// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/providers/autodijelovi_provider.dart';
import 'package:eautokuca_mobile/providers/kosarica_provider.dart';
import 'package:eautokuca_mobile/screens/shop_main_screen.dart';

import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetaljiProizvoda extends StatefulWidget {
  final Autodijelovi? autodio;

  DetaljiProizvoda({Key? key, this.autodio}) : super(key: key);

  @override
  State<DetaljiProizvoda> createState() => _DetaljiProizvodaState();
}

class _DetaljiProizvodaState extends State<DetaljiProizvoda> {
  late AutodijeloviProvider _autodijeloviProvider;
  late KosaricaProvider _kosaricaProvider;
  bool isLoading = true;
  late Autodijelovi? dio;

  @override
  void initState() {
    super.initState();
    _autodijeloviProvider = context.read<AutodijeloviProvider>();
    getData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _kosaricaProvider = context.watch<KosaricaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Detalji ",
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildImage(),
                        SizedBox(height: 16.0),
                        Divider(),
                      ],
                    ),
                  ),
                  _buildFirstPart(),
                  Divider(),
                  dio!.kolicinaNaStanju != null
                      ? _buildSecondPart()
                      : _buildNoDataField(),
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
            padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueGrey[50]),
            child: Column(
              children: [
                Icon(Icons.info),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Proizvod trenutno nije na stanju.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }

  Container _buildSecondPart() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                color: Colors.green[800],
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                dio?.status ?? "",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await _kosaricaProvider.dodajUkosaricu(
                        widget.autodio!, context);
                    MyDialogs.showSuccess(
                        context, "Uspješno dodan proizvod u košaricu", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => ShopMainScreen()));
                    });
                  } catch (e) {
                    MyDialogs.showError(context, e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                ),
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.white,
                  size: 25,
                ),
                label: Text(
                  "Dodaj u košaricu",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            icon: Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 25,
            ),
            label: Text(
              "Dodaj na listu želja",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildFirstPart() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dio?.opis ?? "",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Količina na stanju",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Cijena",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dio?.kolicinaNaStanju.toString() ?? "",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                "${dio?.cijena.toString() ?? ""} KM",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Column(
      children: [
        widget.autodio?.slika != null && widget.autodio?.slika != ""
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                height: 300,
                child: imageFromBase64String(widget.autodio!.slika!),
              )
            : Text("no imgg")
      ],
    );
  }

  Future<void> getData() async {
    try {
      var data =
          await _autodijeloviProvider.getById(widget.autodio!.autodioId!);
      setState(() {
        dio = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
