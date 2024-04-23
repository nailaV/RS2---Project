// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/oprema.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/providers/oprema_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/edit_automobil_popup.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                children: [
                  _buildForms(),
                  imaOpremu
                      ? const Text("Ima opremu")
                      // : MaterialButton(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(20)),
                      //     padding: EdgeInsets.all(15),
                      //     hoverColor: Colors.green,
                      //     color: Colors.yellow[700],
                      //     onPressed: () async {
                      //       try {
                      //         showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return DodajOpremu(car: widget.car!);
                      //           },
                      //         );
                      //       } on Exception catch (e) {
                      //         MyDialogs.showError(context, e.toString());
                      //       }
                      //     },
                      //     child: Text(
                      //       "Dodaj opremu",
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   )
                      : const Text("Nema opremu")
                ],
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
                            children: [_buildInputsOprema()],
                          ),
                        )))
              ],
            )));
  }

  Widget _buildImage() {
    return Column(children: [
      widget.car?.slike != null && widget.car?.slike != ""
          ? Container(
              width: double.infinity,
              height: 200,
              child: imageFromBase64String(widget.car!.slike!),
            )
          : Text("no imgg")
    ]);
  }

  Widget _buildInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["marka"] ?? "",
                decoration: InputDecoration(labelText: "Marka"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["model"] ?? "",
                decoration: InputDecoration(labelText: "Model"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["mjenjac"] ?? "",
                decoration: InputDecoration(labelText: "Transmisija"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["motor"] ?? "",
                decoration: InputDecoration(labelText: "Motor"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["godinaProizvodnje"] ?? "",
                decoration: InputDecoration(labelText: "Godina proizvodnje"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["predjeniKilometri"] ?? "",
                decoration: InputDecoration(labelText: "Pređeni kilometri"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["status"] ?? "",
                decoration: InputDecoration(labelText: "Status"),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["brojSasije"] ?? "",
                decoration: InputDecoration(labelText: "BrojSasije"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["snagaMotora"] ?? "",
                decoration: InputDecoration(labelText: "Snaga motora"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["brojVrata"] ?? "",
                decoration: InputDecoration(labelText: "Broj vrata"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["boja"] ?? "",
                decoration: InputDecoration(labelText: "Boja"),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: _initialValue["cijena"] ?? "",
                decoration: InputDecoration(labelText: "Cijena"),
              ),
              SizedBox(height: 20),
              _buildButtons()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputsOprema() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
        child: Column(children: [
          _buildOpremaTile(
              "Zračni jastuci", opremaAutomobila?.zracniJastuci ?? false),
          SizedBox(height: 20),
          _buildOpremaTile("Bluetooth", opremaAutomobila?.bluetooth ?? false),
          SizedBox(height: 20),
          _buildOpremaTile("Xenon", opremaAutomobila?.xenon ?? false),
          SizedBox(height: 20),
          _buildOpremaTile("Alarm", opremaAutomobila?.alarm ?? false),
          SizedBox(height: 20),
          _buildOpremaTile("Daljinsko ključanje",
              opremaAutomobila?.daljinskoKljucanje ?? false),
          SizedBox(height: 20),
          _buildOpremaTile("Navigacija", opremaAutomobila?.navigacija ?? false)
        ]),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          children: [
            _buildOpremaTile(
                "Servo volan", opremaAutomobila?.servoVolan ?? false),
            SizedBox(height: 20),
            _buildOpremaTile(
                "Auto pilot", opremaAutomobila?.autoPilot ?? false),
            SizedBox(height: 20),
            _buildOpremaTile("Tempomat", opremaAutomobila?.tempomat ?? false),
            SizedBox(height: 20),
            _buildOpremaTile(
                "Parking senzori", opremaAutomobila?.parkingSenzori ?? false),
            SizedBox(height: 20),
            _buildOpremaTile("Grijanje sjedišta",
                opremaAutomobila?.grijanjeSjedista ?? false),
            SizedBox(height: 20),
            _buildOpremaTile(
                "Grijanje volana", opremaAutomobila?.grijanjeVolana ?? false),
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
      children: [
        Icon(
          Icons.edit,
          size: 25,
          color: Colors.black,
        ),
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
        Icon(
          Icons.delete,
          size: 25,
          color: Colors.black,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(15),
          hoverColor: Colors.red,
          color: Colors.yellow[700],
          onPressed: () async {
            try {
              await _carProvider.delete(widget.car!.automobilId!);
              MyDialogs.showSuccess(context, "Uspješno obrisan automobil.", () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const ListaAutomobila()));
              });
            } on Exception catch (e) {
              MyDialogs.showError(context, e.toString());
            }
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
        isLoading = false;
        opremaAutomobila = data;
      });
      print(opremaAutomobila);
    } catch (e) {
      setState(() {
        isLoading = false;
        imaOpremu = false;
        opremaAutomobila = null;
      });
    }
  }
}
