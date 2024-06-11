// ignore_for_file: prefer_const_constructors

import 'package:eautokuca_desktop/models/narudzba.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/narudzba_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NarudzbeScreen extends StatefulWidget {
  const NarudzbeScreen({super.key});

  @override
  State<NarudzbeScreen> createState() => _NarudzbeScreenState();
}

class _NarudzbeScreenState extends State<NarudzbeScreen> {
  late NarudzbaProvider _narudzbaProvider;
  bool isLoading = true;
  String currentState = "Pending";
  int currentPage = 1;
  int pageSize = 6;
  SearchResult<Narudzba>? narudzbaData;

  @override
  void initState() {
    super.initState();
    _narudzbaProvider = context.read<NarudzbaProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "SVE NARUDŽBE",
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  _buildStateFilterButtons(),
                  Expanded(child: _buildOrderTable()),
                ],
              ),
            ),
    );
  }

  Widget _buildStateFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _changeState("Pending"),
          child: Text("Pending"),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                currentState == "Pending" ? Colors.blue[100] : Colors.white,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _changeState("Poslana"),
          child: Text("Poslane"),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                currentState == "Poslana" ? Colors.blue[100] : Colors.white,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _changeState("Otkazana"),
          child: Text("Otkazane"),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                currentState == "Otkazana" ? Colors.blue[100] : Colors.white,
          ),
        ),
      ],
    );
  }

  void _changeState(String state) {
    setState(() {
      currentState = state;
      isLoading = true;
    });
    getData();
  }

  Future<void> getData() async {
    try {
      var data =
          await _narudzbaProvider.getAll(filter: {"Status": currentState});
      setState(() {
        narudzbaData = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Widget _buildOrderTable() {
    return SingleChildScrollView(
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
                "Ime i prezime",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                "Iznos",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                "Datum narudzbe",
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
                "Actions",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: narudzbaData?.result
                  .map(
                    (Narudzba e) => DataRow(cells: [
                      DataCell(Text(e.narudzbaId?.toString() ?? "")),
                      DataCell(Text(e.user)),
                      DataCell(Text(e.ukupniIznos?.toString() ?? "")),
                      DataCell(Text(e.datum)),
                      DataCell(Text(e.status ?? "")),
                      DataCell(_buildActionButtons(e)),
                    ]),
                  )
                  .toList() ??
              [],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Narudzba order) {
    if (order.status == "Pending") {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text("Pošalji"),
          ),
          SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {},
            child: Text("Otkaži"),
          ),
        ],
      );
    } else if (order.status == "Poslana") {
      return ElevatedButton(
        onPressed: () {},
        child: Text("Otkaži"),
      );
    } else {
      return Container();
    }
  }
}
