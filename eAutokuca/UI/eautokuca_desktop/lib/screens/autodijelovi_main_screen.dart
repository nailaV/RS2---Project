// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unused_import

import 'package:eautokuca_desktop/models/autodijelovi.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/autodijelovi_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/dodaj_autodio_popup.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:eautokuca_desktop/widgets/uredi_autodio_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutodijeloviScreen extends StatefulWidget {
  Autodijelovi? autodijelovi;
  AutodijeloviScreen({super.key, this.autodijelovi});

  @override
  State<AutodijeloviScreen> createState() => _AutodijeloviScreenState();
}

class _AutodijeloviScreenState extends State<AutodijeloviScreen> {
  bool isLoading = true;
  late AutodijeloviProvider _autodijeloviProvider;
  SearchResult<Autodijelovi>? autodijeloviResult;

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
        title: "AUTODIJELOVI SHOP",
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return DodajAutodio();
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Dodaj novi proizvod"),
                    ),
                    _buildTable()
                  ],
                ),
              )));
  }

  Future<void> getData() async {
    try {
      var data = await _autodijeloviProvider.getAll();
      setState(() {
        autodijeloviResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Expanded _buildTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.yellow[700]!),
            columns: const [
              DataColumn(
                label: Text(
                  "ID",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Naziv",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Cijena",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Količina",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Status",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Akcija",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: autodijeloviResult?.result
                    .map(
                      (Autodijelovi e) => DataRow(cells: [
                        DataCell(Text(e.autodioId?.toString() ?? "")),
                        // DataCell(
                        //   e.slika != null && e.slika != ""
                        //       ? Container(
                        //           child: imageFromBase64String(e.slika!),
                        //         )
                        //       : Text("No image available."),
                        // ),
                        DataCell(Text(e.naziv ?? "")),
                        DataCell(Text(e.cijena.toString())),
                        DataCell(Text(e.kolicinaNaStanju.toString())),
                        DataCell(Text(e.status ?? "")),
                        DataCell(MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(15),
                          hoverColor: Colors.blue,
                          color: Colors.yellow[700],
                          onPressed: () {
                            print(widget.autodijelovi!.autodioId!);
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return UrediAutodio(
                            //         autodijelovi: widget.autodijelovi!,
                            //       );
                            //     });
                          },
                          child: Text(
                            "Uredi",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                        // DataCell(Text(
                        //   e.stanje.toString() == "true"
                        //       ? "Aktivan"
                        //       : "Neaktivan",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: e.stanje.toString() == "true"
                        //         ? Colors.green
                        //         : Colors.red,
                        //   ),
                        // )),
                      ]),
                    )
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }
}
