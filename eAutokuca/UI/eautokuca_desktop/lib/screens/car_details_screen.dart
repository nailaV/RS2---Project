// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unused_field, unused_import

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/oprema.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/providers/oprema_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/dodaj_opremu_popup.dart';
import 'package:eautokuca_desktop/widgets/edit_automobil_popup.dart';
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
  late CarProvider _carProvider;
  late OpremaProvider _opremaProvider;
  bool imaOpremu = true;

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
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: implement didChangeDependencies
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
                              _buildInputsOprema(),
                              SizedBox(
                                height: 20,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.all(15),
                                hoverColor:
                                    imaOpremu ? Colors.blue : Colors.green,
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
                                            widget.car!.automobilId!, map);
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
                                    MyDialogs.showError(context, e.toString());
                                  }
                                },
                                child: Text(
                                  imaOpremu ? "Uredi opremu" : "Dodaj opremu",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        )))
              ],
            )));
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(15),
          hoverColor: Colors.blue,
          color: Colors.yellow[700],
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
        SizedBox(
          width: 100,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(15),
          hoverColor: Colors.red,
          color: Colors.yellow[700],
          onPressed: () async {
            // try {
            //   print("usao u try");
            //   await _carProvider.delete(widget.car!.automobilId!);
            //   print(widget.car!.automobilId);
            //   MyDialogs.showSuccess(context, "Uspješno obrisan automobil.", () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (builder) => const ListaAutomobila()));
            //   });
            // } on Exception catch (e) {
            //   MyDialogs.showError(context, e.toString());
            // }
          },
          child: Text(
            "Obriši",
            style: TextStyle(color: Colors.white),
          ),
        )
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
}
