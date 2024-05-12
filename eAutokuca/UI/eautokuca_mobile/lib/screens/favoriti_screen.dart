// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables

import 'package:eautokuca_mobile/models/automobil_favorit.dart';
import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/providers/automobilFavorit_provider.dart';
import 'package:eautokuca_mobile/screens/car_details_screen.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritiScreen extends StatefulWidget {
  const FavoritiScreen({super.key});

  @override
  State<FavoritiScreen> createState() => _FavoritiScreenState();
}

class _FavoritiScreenState extends State<FavoritiScreen> {
  late AutomobilFavoritProvider _automobilFavoritProvider;
  late List<AutomobilFavorit>? favoritiData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _automobilFavoritProvider = context.read<AutomobilFavoritProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Favoriti",
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: favoritiData!.isNotEmpty
                      ? Column(
                          children: favoritiData!
                              .map((AutomobilFavorit e) =>
                                  buildProductContainer(e))
                              .toList())
                      : _buildNoDataField(),
                ),
              ));
  }

  GestureDetector buildProductContainer(AutomobilFavorit item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => CarDetailsScreen(
                  car: item.automobil,
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
              child: item.automobil?.slike != ""
                  ? SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: imageFromBase64String(item.automobil!.slike!),
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
                    item.imeAuta,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${item.automobil?.cijena}KM",
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
                Icon(Icons.no_accounts),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nemate dodanih favorita",
                  textAlign: TextAlign.center,
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

  Future<void> getData() async {
    try {
      var data = await _automobilFavoritProvider
          .getFavoriteZaUsera(Authorization.username!);
      setState(() {
        favoritiData = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
