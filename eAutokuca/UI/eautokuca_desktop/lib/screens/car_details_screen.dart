// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CarDetailsScreen extends StatefulWidget {
  Car? car;
  CarDetailsScreen({Key? key, this.car}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};

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
      "slike": widget.car?.slike
    };
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back)),
                        Expanded(
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: "mjenjac",
                                decoration:
                                    InputDecoration(labelText: "Transmisija"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "motor",
                                decoration: InputDecoration(labelText: "Motor"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "godinaProizvodnje",
                                decoration: InputDecoration(
                                    labelText: "Godina proizvodnje"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "predjeniKilometri",
                                decoration: InputDecoration(
                                    labelText: "Pređeni kilometri"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: "brojSasije",
                                decoration:
                                    InputDecoration(labelText: "Broj šasije"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "snagaMotora",
                                decoration:
                                    InputDecoration(labelText: "Snaga motora"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "brojVrata",
                                decoration:
                                    InputDecoration(labelText: "Broj vrata"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "boja",
                                decoration: InputDecoration(labelText: "Boja"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30), // Adjust the height as needed
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    // Implement your save logic here
  }
}
