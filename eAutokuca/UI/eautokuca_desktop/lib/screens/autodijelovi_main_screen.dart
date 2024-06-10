// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eautokuca_desktop/models/autodijelovi.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/autodijelovi_provider.dart';
import 'package:eautokuca_desktop/screens/autodijelovi_detalji_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/dodaj_autodio_popup.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:eautokuca_desktop/widgets/uredi_autodio_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutodijeloviScreen extends StatefulWidget {
  const AutodijeloviScreen({super.key});

  @override
  State<AutodijeloviScreen> createState() => _AutodijeloviScreenState();
}

class _AutodijeloviScreenState extends State<AutodijeloviScreen> {
  bool isLoading = true;
  late AutodijeloviProvider _autodijeloviProvider;
  SearchResult<Autodijelovi>? autodijeloviResult;
  String currentState = "Dostupno";
  int currentPage = 1;
  int pageSize = 6;

  @override
  void initState() {
    super.initState();
    _autodijeloviProvider = context.read<AutodijeloviProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "AUTODIJELOVI SHOP",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRow(context),
                    SizedBox(
                      height: 20,
                    ),
                    _buildGrid(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildPageing(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Row _buildPageing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        currentPage > 1
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage--;
                    isLoading = true;
                  });
                  getData();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 3,
                ),
                child: Icon(Icons.arrow_back),
              )
            : SizedBox.shrink(),
        SizedBox(width: 10),
        currentPage < (autodijeloviResult!.total ?? 0)
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage++;
                    isLoading = true;
                  });
                  getData();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 3,
                ),
                child: Icon(Icons.arrow_forward))
            : SizedBox.shrink(),
      ],
    );
  }

  Row _buildRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return DodajAutodio();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.add_shopping_cart),
          label: Text("Dodaj novi proizvod"),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentState = "Dostupno";
                  isLoading = true;
                });
                getData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentState == "Dostupno"
                    ? Colors.yellow[700]
                    : Colors.white,
              ),
              child: Text(
                "Aktivni",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentState = "Deaktiviran";
                  isLoading = true;
                });
                getData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentState == "Deaktiviran"
                    ? Colors.yellow[700]
                    : Colors.white,
              ),
              child: Text(
                "Deaktivirani",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  GridView _buildGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 20.0,
      mainAxisSpacing: 20.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: autodijeloviResult?.result
              .map(
                (Autodijelovi e) => _buildCard(e),
              )
              .toList() ??
          [],
    );
  }

  Widget _buildCard(Autodijelovi autodijelovi) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            autodijelovi.slika != null && autodijelovi.slika != ""
                ? Container(
                    height: 200,
                    width: double.infinity,
                    child: imageFromBase64String(autodijelovi.slika!),
                  )
                : Text("No image available."),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.car_repair),
                SizedBox(width: 5),
                Text(
                  "${autodijelovi.naziv}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.attach_money),
                SizedBox(width: 5),
                Text(
                  "${autodijelovi.cijena}KM",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.warehouse),
                SizedBox(width: 5),
                Text("Na stanju: ${autodijelovi.kolicinaNaStanju}",
                    style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
                color: Colors.yellow[700],
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => AutodijeloviDetalji(
                          autodioId: autodijelovi.autodioId!)));
                },
                child: Text(
                  "Vidi detalje",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    try {
      var data = await _autodijeloviProvider.getAll(filter: {
        "Status": currentState,
        "Page": currentPage,
        "PageSize": pageSize
      });

      setState(() {
        autodijeloviResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
