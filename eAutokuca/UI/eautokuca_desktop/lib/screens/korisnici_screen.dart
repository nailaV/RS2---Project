// ignore_for_file: unused_field, sized_box_for_whitespace, prefer_const_constructors, unused_import

import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/dodaj_korisnika_popup.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KorisniciScreen extends StatefulWidget {
  const KorisniciScreen({super.key});

  @override
  State<KorisniciScreen> createState() => _KorisniciScreenState();
}

class _KorisniciScreenState extends State<KorisniciScreen> {
  late KorisniciProvider _korisniciProvider;
  SearchResult<Korisnici>? korisniciResult;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _korisniciProvider = context.read<KorisniciProvider>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    getData();
  }

  Future<void> getData() async {
    try {
      var data = await _korisniciProvider.getAll();
      setState(() {
        korisniciResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ok"))
                  ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "KORISNICI",
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return DodajKorisnika();
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.person_add),
                label: Text("Registruj novog korisnika"),
              ),
              _buildUserTable()
            ],
          )),
        ));
  }

  Expanded _buildUserTable() {
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
                  "Slika",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Ime",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Prezime",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Username",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Email",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Telefon",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Registrovan",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  "Poruka",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              // DataColumn(
              //   label: Text(
              //     "Akcija",
              //     style: TextStyle(fontStyle: FontStyle.italic),
              //   ),
              // ),
              DataColumn(
                label: Text(
                  "Stanje",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: korisniciResult?.result
                    .map(
                      (Korisnici e) => DataRow(cells: [
                        DataCell(Text(e.korisnikId?.toString() ?? "")),
                        DataCell(
                          e.slika != null && e.slika != ""
                              ? Container(
                                  child: imageFromBase64String(e.slika!),
                                )
                              : Text("No image available."),
                        ),
                        DataCell(Text(e.ime ?? "")),
                        DataCell(Text(e.prezime ?? "")),
                        DataCell(Text(e.username ?? "")),
                        DataCell(Text(e.email ?? "")),
                        DataCell(Text(e.telefon ?? "")),
                        DataCell(Text(e.datumRegistracije.toString())),
                        DataCell(MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(15),
                          hoverColor: Colors.blue,
                          color: Colors.yellow[700],
                          onPressed: () {},
                          child: Text(
                            "Poruka",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                        // DataCell(MaterialButton(
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10)),
                        //   padding: EdgeInsets.all(15),
                        //   hoverColor: Colors.red,
                        //   color: Colors.yellow[700],
                        //   onPressed: () async {
                        //     try {
                        //       await _korisniciProvider.delete(e.korisnikId!);
                        //       MyDialogs.showSuccess(
                        //           context, "Uspješno obrisan korisnik", () {
                        //         Navigator.of(context).push(MaterialPageRoute(
                        //             builder: ((context) => KorisniciScreen())));
                        //       });
                        //     } catch (e) {
                        //       MyDialogs.showError(context, e.toString());
                        //     }
                        //   },
                        //   child: Text(
                        //     "Obriši",
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // )),
                        DataCell(Text(
                          e.stanje.toString() == "true"
                              ? "Aktivan"
                              : "Neaktivan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: e.stanje.toString() == "true"
                                ? Colors.green
                                : Colors.red,
                          ),
                        )),
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
