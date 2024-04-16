// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable, use_build_context_synchronously

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
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
      "slike": widget.car?.slike
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                name: "model",
                                decoration: InputDecoration(labelText: "Model"),
                              ),
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "marka",
                                decoration: InputDecoration(labelText: "Marka"),
                              ),
                              SizedBox(height: 20),
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
                              SizedBox(height: 20),
                              FormBuilderTextField(
                                name: "status",
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
                              SizedBox(height: 30),
                              FormBuilderTextField(
                                name: "cijena",
                                decoration:
                                    InputDecoration(labelText: "Cijena"),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      _formKey.currentState?.saveAndValidate();

                                      print(_formKey.currentState?.value);

                                      try {
                                        if (widget.car == null) {
                                          await _carProvider.insert(
                                              _formKey.currentState?.value);
                                        } else {
                                          await _carProvider.update(
                                              widget.car!.automobilId!,
                                              _formKey.currentState?.value);
                                        }
                                      } on Exception catch (e) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text(e.toString()),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text("Ok"))
                                                    ]));
                                      }
                                    },
                                    child: Text('Sačuvaj'),
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
      ),
    );
  }
}
