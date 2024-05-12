// ignore_for_file: deprecated_member_use, unused_local_variable, unused_import, prefer_const_constructors

import 'dart:io';

import 'package:eautokuca_desktop/models/report.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/report_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Report? report;
  bool isLoading = true;
  List<Report>? reportData;
  late ReportProvider _reportProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reportProvider = context.read<ReportProvider>();
    getData();
  }

  Future<void> getData() async {
    try {
      var data = await _reportProvider.getSve(filter: {"mjesec": 13});
      setState(() {
        reportData = data;
        isLoading = false;
      });
      print(reportData?[0].datumProdaje);
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Izvještaj",
      child: Center(
        child: Column(
          children: [
            Text("Report"),
            ElevatedButton(
                onPressed: () {
                  generatePdf();
                },
                child: Text("Preuzmi PDF")),
          ],
        ),
      ),
    );
  }

  void generatePdf() async {
    try {
      var pdf = pw.Document();
      // final regularFont = await rootBundle.load('lib/fonts/Roboto-Regular.ttf');
      // final boldFont = await rootBundle.load('lib/fonts/Roboto-Bold.ttf');

      // final regularttf = pw.Font.ttf(regularFont.buffer.asByteData());
      // final boldttf = pw.Font.ttf(boldFont.buffer.asByteData());

      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(children: [
          pw.Text('eAutokuca',
              style: pw.TextStyle(fontSize: 15, wordSpacing: 2)),
          pw.SizedBox(height: 15),
          pw.Table.fromTextArray(
              cellStyle: pw.TextStyle(fontSize: 14),
              headerStyle: pw.TextStyle(fontSize: 10, color: PdfColors.white),
              border: null,
              headerDecoration: pw.BoxDecoration(color: PdfColors.yellow700),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight
              },
              cellHeight: 20,
              headers: ['DATUM', 'BOJA'],
              data: reportData != null && reportData!.isNotEmpty
                  ? reportData!
                      .map((e) => [e.datumProdaje, e.automobil!.boja])
                      .toList()
                  : []),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 0.5),
          pw.SizedBox(height: 15),
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
