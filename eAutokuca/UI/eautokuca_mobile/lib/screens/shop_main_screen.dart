// ignore_for_file: prefer_const_constructors

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/models/search_result.dart';
import 'package:eautokuca_mobile/providers/autodijelovi_provider.dart';
import 'package:eautokuca_mobile/screens/detalji_proizvoda.dart';

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
  bool isLoading = true;
  SearchResult<Autodijelovi>? autodijeloviData;

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
                  //_buildSeacrh(),
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

  GestureDetector buildProductContainer(Autodijelovi item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => DetaljiProizvoda()));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueGrey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey[50],
                  ),
                  height: 200,
                  width: 300,
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
                const SizedBox(height: 10),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.cijena}KM",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
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
