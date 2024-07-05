// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unused_field, unused_import

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/komentari.dart';
import 'package:eautokuca_desktop/models/oprema.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/providers/komentari_provider.dart';
import 'package:eautokuca_desktop/providers/oprema_provider.dart';
import 'package:eautokuca_desktop/providers/report_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/dodaj_opremu_popup.dart';
import 'package:eautokuca_desktop/widgets/edit_automobil_popup.dart';
import 'package:eautokuca_desktop/widgets/komentari_popup.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CarDetailsScreen extends StatefulWidget {
  Car? car;
  CarDetailsScreen({Key? key, this.car}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey1 = GlobalKey<FormBuilderState>();
  late Oprema? opremaAutomobila;
  late List<Komentari>? komentariResult = [];
  late CarProvider _carProvider;
  late ReportProvider _reportProvider;
  late OpremaProvider _opremaProvider;
  late KomentariProvider _komentariProvider;
  bool imaOpremu = true;
  bool isVisible = false;

  void _toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Map<String, dynamic> _initialValue = {};

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      "motor": widget.car?.motor,
      "mjenjac": widget.car?.mjenjac,
      "boja": widget.car?.boja,
      "cijena": widget.car?.cijena.toString(),
      "godinaProizvodnje": widget.car?.godinaProizvodnje.toString(),
      "predjeniKilometri": widget.car?.predjeniKilometri.toString(),
      "brojSasije": widget.car?.brojSasije,
      "snagaMotora": widget.car?.snagaMotora,
      "brojVrata": widget.car?.brojVrata.toString(),
      "model": widget.car?.model,
      "marka": widget.car?.marka,
      "status": widget.car?.status,
      "slika": widget.car?.slike
    };
    _carProvider = context.read<CarProvider>();
    _opremaProvider = context.read<OpremaProvider>();
    _reportProvider = context.read<ReportProvider>();
    _komentariProvider = context.read<KomentariProvider>();
    getData();
    getKomentare();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "${widget.car?.marka} ${widget.car?.model}",
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [_buildForms()],
              ),
            ),
    );
  }

  Widget _buildForms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        Expanded(
          flex: 6,
          child: _buildFirstForm(),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: _buildOprema(),
        ),
      ],
    );
  }

  FormBuilder _buildFirstForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blueGrey[50]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildImage(),
                        Column(
                          children: <Widget>[
                            TextButton(
                                onPressed: _toggleVisibility,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isVisible
                                          ? "Sakrij komentare"
                                          : "Vidi komentare",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      isVisible
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: Colors.black,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: isVisible,
                              child: (komentariResult != null &&
                                      komentariResult!.isNotEmpty)
                                  ? Column(
                                      children: komentariResult!
                                          .map((Komentari k) => buildRes(k))
                                          .toList(),
                                    )
                                  : _buildNoComments(),
                            ),
                          ],
                        ),
                        _buildInputs(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildButtons()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildRes(Komentari object) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRow(Icons.person, "Korisnik", object.user),
          const SizedBox(height: 10),
          if (object.sadrzaj != null)
            buildRow(Icons.comment_rounded, "Komentar", object.sadrzaj!),
          const SizedBox(height: 10),
          buildRow(Icons.watch_later_outlined, "Datum", object.datum),
        ],
      ),
    );
  }

  Row buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  FormBuilder _buildOprema() {
    return FormBuilder(
        key: _formKey1,
        initialValue: _initialValue,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueGrey[50]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              opremaAutomobila?.alarm == null
                                  ? _buildNoDataField()
                                  : _buildInputsOprema(),
                              SizedBox(
                                height: 20,
                              ),
                              widget.car!.status == "Prodan"
                                  ? SizedBox.shrink()
                                  : MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: EdgeInsets.all(15),
                                      hoverColor: imaOpremu
                                          ? Colors.blue
                                          : Colors.green,
                                      color: Colors.yellow[700],
                                      onPressed: () async {
                                        try {
                                          var result = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DodajOpremu(
                                                  oprema: opremaAutomobila);
                                            },
                                          );
                                          if (result != null) {
                                            Map<String, dynamic> map =
                                                Map.from(result);
                                            map["automobilId"] =
                                                widget.car!.automobilId;
                                            if (imaOpremu) {
                                              _opremaProvider.update(
                                                  widget.car!.automobilId!,
                                                  map);
                                            } else {
                                              _opremaProvider.insert(map);
                                            }
                                            setState(() {
                                              isLoading = true;
                                            });

                                            await getData();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CarDetailsScreen(
                                                        car: widget.car!,
                                                      )),
                                            );
                                          }
                                        } on Exception catch (e) {
                                          MyDialogs.showError(
                                              context, e.toString());
                                        }
                                      },
                                      child: Text(
                                        opremaAutomobila?.alarm != null
                                            ? "Uredi opremu"
                                            : "Dodaj opremu",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                            ],
                          ),
                        )))
              ],
            )));
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
                Icon(Icons.info),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nema podataka o dodatnoj opremi za ovaj automobil.",
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

  Padding _buildNoComments() {
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
                Icon(Icons.info),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nema komentara.",
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

  Widget _buildImage() {
    return Column(
      children: [
        widget.car?.slike != null && widget.car?.slike != ""
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                height: 300,
                child: imageFromBase64String(widget.car!.slike!),
              )
            : Text("no imgg")
      ],
    );
  }

  Widget _buildRoundedTextFormField(
      {required String label, required String initialValue}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: TextFormField(
        readOnly: true,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        ),
      ),
    );
  }

  Widget _buildInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              _buildRoundedTextFormField(
                  label: "Marka", initialValue: _initialValue["marka"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Model", initialValue: _initialValue["model"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Transmisija",
                  initialValue: _initialValue["mjenjac"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Motor", initialValue: _initialValue["motor"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Godina proizvodnje",
                  initialValue: _initialValue["godinaProizvodnje"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Pređeni kilometri",
                  initialValue: _initialValue["predjeniKilometri"] ?? " "),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              _buildRoundedTextFormField(
                  label: "Status",
                  initialValue: _initialValue["status"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Broj šasije",
                  initialValue: _initialValue["brojSasije"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Snaga motora",
                  initialValue: _initialValue["snagaMotora"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Broj vrata",
                  initialValue: _initialValue["brojVrata"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Boja", initialValue: _initialValue["boja"] ?? " "),
              SizedBox(height: 10),
              _buildRoundedTextFormField(
                  label: "Cijena",
                  initialValue: _initialValue["cijena"] ?? " "),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputsOprema() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: Column(children: [
                _buildOpremaTile(
                    "Zračni jastuci", opremaAutomobila?.zracniJastuci ?? false),
                SizedBox(height: 10),
                _buildOpremaTile(
                    "Bluetooth", opremaAutomobila?.bluetooth ?? false),
                SizedBox(height: 10),
                _buildOpremaTile("Xenon", opremaAutomobila?.xenon ?? false),
                SizedBox(height: 10),
                _buildOpremaTile("Alarm", opremaAutomobila?.alarm ?? false),
                SizedBox(height: 10),
                _buildOpremaTile("Daljinsko ključanje",
                    opremaAutomobila?.daljinskoKljucanje ?? false),
                SizedBox(height: 10),
                _buildOpremaTile(
                    "Navigacija", opremaAutomobila?.navigacija ?? false),
              ]),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  _buildOpremaTile(
                      "Servo volan", opremaAutomobila?.servoVolan ?? false),
                  SizedBox(height: 10),
                  _buildOpremaTile(
                      "Auto pilot", opremaAutomobila?.autoPilot ?? false),
                  SizedBox(height: 10),
                  _buildOpremaTile(
                      "Tempomat", opremaAutomobila?.tempomat ?? false),
                  SizedBox(height: 10),
                  _buildOpremaTile("Parking senzori",
                      opremaAutomobila?.parkingSenzori ?? false),
                  SizedBox(height: 10),
                  _buildOpremaTile("Grijanje sjedišta",
                      opremaAutomobila?.grijanjeSjedista ?? false),
                  SizedBox(height: 10),
                  _buildOpremaTile("Grijanje volana",
                      opremaAutomobila?.grijanjeVolana ?? false),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildOpremaTile(String title, bool value) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: null,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildButtons() {
    if (widget.car!.status == "Prodan") {
      return SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(15),
          hoverColor: Colors.blue,
          color: Colors.blue[700],
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) {
                return EditAutomobil(
                  car: widget.car!,
                );
              },
            );
          },
          child: Text(
            "Uredi",
            style: TextStyle(color: Colors.white),
          ),
        ),
        widget.car!.status == "Aktivan"
            ? MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(15),
                hoverColor: Colors.red,
                color: Colors.red[700],
                onPressed: () {
                  MyDialogs.showQuestion(context,
                      "Da li ste sigurni da želite deaktivirati automobil?",
                      () async {
                    try {
                      await _carProvider
                          .promijeniStanje(widget.car!.automobilId!);
                      setState(() {
                        isLoading = true;
                      });
                      MyDialogs.showSuccess(
                          context, "Uspješno deaktiviran automobil.", () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => ListaAutomobila()));
                      });
                    } catch (e) {
                      MyDialogs.showError(context, e.toString());
                    }
                  });
                },
                child: Text(
                  "Deaktiviraj",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(15),
                hoverColor: Colors.green,
                color: Colors.green[700],
                onPressed: () async {
                  try {
                    await _carProvider.aktiviraj(widget.car!.automobilId!);
                    setState(() {
                      isLoading = true;
                    });
                    MyDialogs.showSuccess(
                        context, "Uspješno aktiviran automobil.", () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => ListaAutomobila()));
                    });
                  } catch (e) {
                    MyDialogs.showError(context, e.toString());
                  }
                },
                child: Text(
                  "Aktiviraj",
                  style: TextStyle(color: Colors.white),
                ),
              ),
        widget.car!.status == "Aktivan"
            ? MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(15),
                hoverColor: Colors.orange,
                color: Colors.orange[700],
                onPressed: () async {
                  try {
                    await _reportProvider.insert({
                      "automobilId": widget.car?.automobilId!,
                      "prihodi": widget.car?.cijena
                    });
                    MyDialogs.showSuccess(context, "Uspješno prodan automobil",
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => ListaAutomobila()));
                    });
                  } catch (e) {
                    MyDialogs.showError(context, e.toString());
                  }
                },
                child: Text(
                  "Prodaj",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Future<void> getData() async {
    try {
      var data =
          await _opremaProvider.getOpremuZaAutomobil(widget.car!.automobilId!);
      setState(() {
        opremaAutomobila = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        opremaAutomobila = null;
        isLoading = false;
        imaOpremu = false;
      });
    }
  }

  Future<void> getKomentare() async {
    try {
      var data =
          await _komentariProvider.getKomentareZaAuto(widget.car!.automobilId!);
      setState(() {
        komentariResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      MyDialogs.showError(context, e.toString());
    }
  }
}
