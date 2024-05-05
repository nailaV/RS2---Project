import 'package:eautokuca_desktop/models/rezervacija.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/rezervacija_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      var data = await _rezervacijaProvider.getAll();
      setState(() {
        rezervacijaResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "REZERVACIJE",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.black)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.grey[200]!),
                headingTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                columns: const [
                  DataColumn(
                    label: Text(
                      "ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Datum",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
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
                          child: Text(e.rezervacijaId?.toString() ?? ""),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(e.datum),
                        ),
                      ),
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
                            onPressed: () {},
                            child:
                                Text("Završi", style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
