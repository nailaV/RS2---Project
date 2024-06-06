// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:io';

import 'package:eautokuca_desktop/models/report.dart';
import 'package:eautokuca_desktop/providers/report_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isLoading = true;
  List<Report>? reportData;
  late ReportProvider _reportProvider;
  List<String>? prodaneMarke;
  String? selectedMarka;
  int selectedMonth = 13;
  final Map<int, String> monthMapa = {
    1: 'Januar',
    2: 'Februar',
    3: 'Mart',
    4: 'April',
    5: 'Maj',
    6: 'Juni',
    7: 'Juli',
    8: 'August',
    9: 'Septembar',
    10: 'Oktobar',
    11: 'Novembar',
    12: 'Decembar',
  };

  @override
  void initState() {
    super.initState();
    _reportProvider = context.read<ReportProvider>();
    getData();
    loadBrands();
  }

  Future<void> getData() async {
    try {
      var data = await _reportProvider.getSve(filter: {"mjesec": 13});
      setState(() {
        reportData = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Future<void> loadBrands() async {
    try {
      var data = await _reportProvider.getSveProdaneMarke();
      setState(() {
        prodaneMarke = data;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izvještaj",
      child: Container(
        constraints: BoxConstraints(maxWidth: 2000),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildReportTable(),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blueGrey[50],
                padding: EdgeInsets.all(16),
                child: _buildSearch(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: DropdownButton<int>(
            value: selectedMonth,
            onChanged: (value) {
              setState(() {
                selectedMonth = value!;
              });
            },
            items: List.generate(
              13,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Center(
                  child: Text(
                    monthMapa[index + 1] ?? 'Svi mjeseci',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          child: DropdownButton<String>(
            value: selectedMarka ?? "Sve marke",
            onChanged: (value) {
              setState(() {
                selectedMarka = value;
              });
            },
            items: prodaneMarke?.map((carModel) {
              return DropdownMenuItem<String>(
                value: carModel,
                child: Center(
                  child: Text(
                    carModel,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var data = await _reportProvider.getSve(
              filter: {"Mjesec": selectedMonth, "Marka": selectedMarka},
            );
            setState(() {
              reportData = data;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded),
              SizedBox(
                width: 3,
              ),
              Text("Pretraži"),
            ],
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            generatePdf();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf_rounded),
              SizedBox(
                width: 3,
              ),
              Text("Preuzmi PDF"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportTable() {
    double totalSum = reportData?.fold<double>(
            0,
            (previousValue, element) =>
                previousValue + (element.automobil!.cijena ?? 0)) ??
        0;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.yellow[700]!),
                columns: const [
                  DataColumn(
                    label: Text(
                      "Datum prodaje",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Marka automobila",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Model automobila",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Godina proizvodnje",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Cijena",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: reportData
                        ?.map(
                          (Report e) => DataRow(cells: [
                            DataCell(Text(e.datum)),
                            DataCell(Text(e.automobil!.marka.toString())),
                            DataCell(Text(e.automobil!.model.toString())),
                            DataCell(Text(
                                e.automobil!.godinaProizvodnje.toString())),
                            DataCell(Text(e.automobil!.cijena.toString())),
                          ]),
                        )
                        .toList() ??
                    [],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: 25,
              color: Colors.black,
            ),
            Text(
              "Ukupan prihod: ${totalSum.toStringAsFixed(2)}KM",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  void generatePdf() async {
    try {
      var pdf = pw.Document();

      double totalSum = reportData?.fold<double>(
              0,
              (previousValue, element) =>
                  previousValue + (element.automobil!.cijena ?? 0)) ??
          0;

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Mjesecni izvjestaj',
                  style: pw.TextStyle(
                      fontSize: 30, wordSpacing: 2, color: PdfColors.blue200)),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('LenaAuto', style: pw.TextStyle(fontSize: 12)),
                  pw.Text('Ismeta Sarica 10',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.Text('71370 Breza', style: pw.TextStyle(fontSize: 12)),
                  pw.Text('TEL: +387 61 559 390',
                      style: pw.TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          pw.Divider(thickness: 0.5),
          pw.SizedBox(height: 15),
          pw.Text(
            monthMapa[selectedMonth] ?? "Svi mjeseci",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            cellStyle: pw.TextStyle(fontSize: 14),
            headerStyle: pw.TextStyle(fontSize: 10, color: PdfColors.white),
            border: null,
            headerDecoration: pw.BoxDecoration(color: PdfColors.yellow700),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.centerRight,
            },
            cellHeight: 20,
            headers: ['DATUM', 'AUTOMOBIL', 'PRIHODI'],
            data: reportData != null && reportData!.isNotEmpty
                ? reportData!.map((e) => [e.datum, e.auto, e.cijena]).toList()
                : [],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 0.5),
          pw.SizedBox(height: 15),
          pw.Table.fromTextArray(
            cellStyle:
                pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            border: null,
            cellHeight: 20,
            headerDecoration: pw.BoxDecoration(color: PdfColors.green700),
            headerStyle: pw.TextStyle(fontSize: 12, color: PdfColors.white),
            headerAlignment: pw.Alignment.topRight,
            cellAlignment: pw.Alignment.topRight,
            headers: ['Ukupni prihodi', ''],
            data: [
              ['', totalSum.toStringAsFixed(2)]
            ],
          ),
        ]),
      ));

      final dir = await getApplicationDocumentsDirectory();
      final vrijeme = DateTime.now().millisecondsSinceEpoch;
      String path = '${dir.path}/report_$vrijeme.pdf';
      File file = File(path);
      file.writeAsBytes(await pdf.save());
      setState(() {
        isLoading = false;
      });
      MyDialogs.showSuccess(context, 'Izvještaj sačuvan na lokaciji $path', () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
