// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eautokuca_desktop/models/rezervacija.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/rezervacija_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({Key? key}) : super(key: key);

  @override
  State<RezervacijeScreen> createState() => _RezervacijeScreenState();
}

class _RezervacijeScreenState extends State<RezervacijeScreen> {
  bool isLoading = true;
  late RezervacijaProvider _rezervacijaProvider;
  SearchResult<Rezervacija>? rezervacijaResult;
  DateTime currentDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
  }

  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    getData();
  }

  Future<void> getData() async {
    try {
      var data =
          await _rezervacijaProvider.getAll(filter: {"datum": currentDate});
      setState(() {
        rezervacijaResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  void sljedeciDan() {
    setState(() {
      currentDate = currentDate.add(Duration(days: 1));
      getData();
    });
  }

  void prethodniDan() {
    setState(() {
      currentDate = currentDate.subtract(Duration(days: 1));
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "REZERVACIJE",
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Datum",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: prethodniDan,
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(DateFormat('yyyy-MM-dd').format(currentDate)),
                    IconButton(
                      onPressed: sljedeciDan,
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                rezervacijaResult == null || rezervacijaResult!.result.isEmpty
                    ? _buildNoReservationField()
                    : _buildReservationTable(),
              ],
            ),
    );
  }

  Padding _buildNoReservationField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueGrey[50]),
            child: Column(
              children: [
                Icon(Icons.info),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nema rezervacija ",
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

  DataTable _buildReservationTable() {
    return DataTable(
      headingRowColor:
          MaterialStateColor.resolveWith((states) => Colors.yellow[700]!),
      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      dataRowColor:
          MaterialStateColor.resolveWith((states) => Colors.blueGrey[50]!),
      columns: const [
        DataColumn(
          label: Text(
            "Vrijeme",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            "Automobil",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            "Klijent",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            "Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            "Akcije",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      rows: (rezervacijaResult?.result ?? []).map((Rezervacija e) {
        return DataRow(
          cells: [
            DataCell(
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(e.vrijeme),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(e.auto),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(e.user),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(e.status ?? ""),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(236, 239, 241, 1.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Završi",
                      style:
                          TextStyle(fontSize: 14, color: Colors.yellow[700])),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
