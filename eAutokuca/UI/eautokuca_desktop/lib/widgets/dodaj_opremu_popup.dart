// ignore_for_file: must_be_immutable, prefer_const_constructors, use_build_context_synchronously, unused_import

import 'package:eautokuca_desktop/models/oprema.dart';
import 'package:eautokuca_desktop/providers/oprema_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';

class DodajOpremu extends StatefulWidget {
  Oprema? oprema;
  DodajOpremu({super.key, this.oprema});

  @override
  State<DodajOpremu> createState() => _DodajOpremuState();
}

class _DodajOpremuState extends State<DodajOpremu> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  Oprema? _oprema;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.oprema != null) {
      _oprema = widget.oprema;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[300],
      child: Container(
        width: 600,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: !isLoading
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.3,
                      color: Colors.blueGrey,
                      height: 25,
                    ),
                    //_buildForm(),
                    FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildCheckBox("zracniJastuci", "Zračni jastuci",
                                _oprema?.zracniJastuci ?? false),
                            _buildCheckBox("bluetooth", "Bluetooth",
                                _oprema?.bluetooth ?? false),
                            _buildCheckBox(
                                "xenon", "Xenon", _oprema?.xenon ?? false),
                            _buildCheckBox(
                                "alarm", "Alarm", _oprema?.alarm ?? false),
                            _buildCheckBox(
                                "daljinskoKljucanje",
                                "Daljinsko ključanje",
                                _oprema?.daljinskoKljucanje ?? false),
                            _buildCheckBox("navigacija", "Navigacija",
                                _oprema?.navigacija ?? false),
                            _buildCheckBox("servoVolan", "Servo volan",
                                _oprema?.servoVolan ?? false),
                            _buildCheckBox("autoPilot", "Auto pilot",
                                _oprema?.autoPilot ?? false),
                            _buildCheckBox("tempomat", "Tempomat",
                                _oprema?.tempomat ?? false),
                            _buildCheckBox("parkingSenzori", "Parking senzori",
                                _oprema?.parkingSenzori ?? false),
                            _buildCheckBox(
                                "grijanjeSjedista",
                                "Grijanje sjedišta",
                                _oprema?.grijanjeSjedista ?? false),
                            _buildCheckBox("grijanjeVolana", "Grijanje volana",
                                _oprema?.grijanjeVolana ?? false),
                          ],
                        )),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 42,
                      child: buildButtons(context),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow[700],
                  ),
                ),
        ),
      ),
    );
  }

  // Widget _buildForm() {
  //   return FormBuilder(
  //     key: _formKey,
  //     child: Center(
  //       child: Wrap(
  //         children: [
  //           _buildCheckBox("zracniJastuci", "Zračni jastuci"),
  //           _buildCheckBox("bluetooth", "Bluetooth"),
  //           _buildCheckBox("xenon", "Xenon"),
  //           _buildCheckBox("alarm", "Alarm"),
  //           _buildCheckBox("daljinskoKljucanje", "Daljinsko ključanje"),
  //           _buildCheckBox("navigacija", "Navigacija"),
  //           _buildCheckBox("servoVolan", "Servo volan"),
  //           _buildCheckBox("autoPilot", "Auto pilot"),
  //           _buildCheckBox("tempomat", "Tempomat"),
  //           _buildCheckBox("parkingSenzori", "Parking senzori"),
  //           _buildCheckBox("grijanjeSjedista", "Grijanje sjedišta"),
  //           _buildCheckBox("grijanjeVolana", "Grijanje volana"),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  MaterialButton buildButtons(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.yellow[700],
      onPressed: () {
        if (_formKey.currentState!.saveAndValidate()) {
          Navigator.of(context).pop(_formKey.currentState!.value);
        }
        // setState(() {
        //   isLoading = true;
        // });
        // insertuj();
      },
      child: const Text(
        'Dodaj',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Container _buildCheckBox(String name, String title, bool initialValuee) {
    return Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        width: 230,
        child: FormBuilderCheckbox(
          initialValue: initialValuee,
          name: name,
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ));
  }
}
