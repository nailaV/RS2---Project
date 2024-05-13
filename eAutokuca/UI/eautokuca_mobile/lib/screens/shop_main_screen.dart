// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_final_fields

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/models/search_result.dart';
import 'package:eautokuca_mobile/providers/autodijelovi_provider.dart';
import 'package:eautokuca_mobile/providers/kosarica_provider.dart';

import 'package:eautokuca_mobile/screens/detalji_proizvoda.dart';
import 'package:eautokuca_mobile/screens/kosarica_screen.dart';

import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopMainScreen extends StatefulWidget {
  const ShopMainScreen({super.key});

  @override
  State<ShopMainScreen> createState() => _ShopMainScreenState();
}

class _ShopMainScreenState extends State<ShopMainScreen> {
  late AutodijeloviProvider _autodijeloviProvider;
  late KosaricaProvider _kosaricaProvider;

  bool isLoading = true;
  SearchResult<Autodijelovi>? autodijeloviData;
  TextEditingController _FTSController = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _kosaricaProvider = context.read<KosaricaProvider>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autodijeloviProvider = context.read<AutodijeloviProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Shop",
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSeacrh(),
                  SizedBox(
                    height: 20,
                  ),
                  (autodijeloviData != null)
                      ? Column(
                          children: autodijeloviData?.list
                                  .map((Autodijelovi e) =>
                                      buildProductContainer(e))
                                  .toList() ??
                              [],
                        )
                      : const Center(
                          child: Text(
                            "Nema proizvoda",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildSeacrh() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pretraži..",
                labelStyle: TextStyle(color: Colors.yellow),
                prefixIcon: Icon(Icons.search, color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                ),
              ),
              controller: _FTSController,
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.all(10),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              var data = await _autodijeloviProvider
                  .getAll(filter: {'FullTextSearch': _FTSController.text});
              setState(() {
                autodijeloviData = data;
              });
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          Ink(
            decoration: ShapeDecoration(
                shape: CircleBorder(), color: Colors.yellow[700]),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const KosaricaScreen(),
                ));
              },
              icon: Stack(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 40,
                    color: Colors.white,
                  ),
                  if (_kosaricaProvider.kosarica.items.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          _kosaricaProvider.kosarica.items.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildProductContainer(Autodijelovi item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => DetaljiProizvoda(
                  autodio: item,
                )));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueGrey[50],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey[50],
              ),
              height: 150,
              width: 150,
              child: item.slika != ""
                  ? SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: imageFromBase64String(item.slika!),
                    )
                  : const Center(
                      child: Icon(
                        Icons.no_photography,
                        size: 35,
                        color: Colors.black87,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.naziv ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${item.cijena}KM",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    try {
      var data = await _autodijeloviProvider.getAll();
      setState(() {
        autodijeloviData = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
