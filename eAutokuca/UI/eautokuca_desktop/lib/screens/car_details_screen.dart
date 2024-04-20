// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable, use_build_context_synchronously

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
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
  late CarProvider _carProvider;

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
      "slikaBase64": widget.car?.slike
    };

    _carProvider = context.read<CarProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO: implement didChangeDependencies
    // if (widget.car != null) {
    // setState(() {
    // _formKey.currentState?.patchValue({"motor": widget.car?.motor});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "${widget.car?.marka} ${widget.car?.model}",
      child: _buildForm(),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blueGrey[50]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: _initialValue["marka"] ?? "",
                                    decoration:
                                        InputDecoration(labelText: "Marka"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: _initialValue["model"] ?? "",
                                    decoration:
                                        InputDecoration(labelText: "Model"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue:
                                        _initialValue["mjenjac"] ?? "",
                                    decoration: InputDecoration(
                                        labelText: "Transmisija"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: _initialValue["motor"] ?? "",
                                    decoration:
                                        InputDecoration(labelText: "Motor"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue:
                                        _initialValue["godinaProizvodnje"] ??
                                            "",
                                    decoration: InputDecoration(
                                        labelText: "Godina proizvodnje"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue:
                                        _initialValue["predjeniKilometri"] ??
                                            "",
                                    decoration: InputDecoration(
                                        labelText: "Pređeni kilometri"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: _initialValue["status"] ?? "",
                                    decoration:
                                        InputDecoration(labelText: "Status"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    initialValue:
                                        _initialValue["brojSasije"] ?? "",
                                    decoration: InputDecoration(
                                        labelText: "BrojSasije"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue:
                                        _initialValue["snagaMotora"] ?? "",
                                    decoration: InputDecoration(
                                        labelText: "Snaga motora"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue:
                                        _initialValue["brojVrata"] ?? "",
                                    decoration: InputDecoration(
                                        labelText: "Broj vrata"),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: _initialValue["boja"] ?? "",
                                    decoration:
                                        InputDecoration(labelText: "Boja"),
                                  ),
                                  SizedBox(height: 30),
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: _initialValue["cijena"] ?? "",
                                    decoration:
                                        InputDecoration(labelText: "Cijena"),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                                      SizedBox(width: 20),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: EdgeInsets.all(15),
                                        hoverColor: Colors.red,
                                        color: Colors.yellow[700],
                                        onPressed: () async {
                                          try {
                                            await _carProvider.delete(
                                                widget.car!.automobilId!);
                                            MyDialogs.showSuccess(context,
                                                "Uspješno obrisan automobil.",
                                                () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          const ListaAutomobila()));
                                            });
                                          } on Exception catch (e) {
                                            MyDialogs.showError(
                                                context, e.toString());
                                          }
                                        },
                                        child: Text(
                                          "Obriši",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
