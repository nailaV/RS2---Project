// ignore_for_file: must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'package:eautokuca_desktop/providers/oprema_provider.dart';
import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';

class DodajOpremu extends StatefulWidget {
  Car car;
  DodajOpremu({super.key, required this.car});

  @override
  State<DodajOpremu> createState() => _DodajOpremuState();
}

class _DodajOpremuState extends State<DodajOpremu> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  Map<String, dynamic> _initialValue = {};
  late OpremaProvider _opremaProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _opremaProvider = context.read<OpremaProvider>();
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
          child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
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
                        _buildForm(),
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
                    )),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Center(
        child: Wrap(
          children: [
            _buildCheckBox("zracniJastuci", "Zračni jastuci"),
            _buildCheckBox("bluetooth", "Bluetooth"),
            _buildCheckBox("xenon", "Xenon"),
            _buildCheckBox("alarm", "Alarm"),
            _buildCheckBox("daljinskoKljucanje", "Daljinsko ključanje"),
            _buildCheckBox("navigacija", "Navigacija"),
            _buildCheckBox("servoVolan", "Servo volan"),
            _buildCheckBox("autoPilot", "Auto pilot"),
            _buildCheckBox("tempomat", "Tempomat"),
            _buildCheckBox("parkingSenzori", "Parking senzori"),
            _buildCheckBox("grijanjeSjedista", "Grijanje sjedišta"),
            _buildCheckBox("grijanjeVolana", "Grijanje volana"),
          ],
        ),
      ),
    );
  }

  MaterialButton buildButtons(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.yellow[700],
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        insertuj();
      },
      child: const Text(
        'Dodaj',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> insertuj() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> map = Map.from(_formKey.currentState!.value);
        map["automobilId"] = widget.car.automobilId;
        try {
          await _opremaProvider.insert(map);
          setState(() {
            isLoading = false;
          });
          MyDialogs.showSuccess(context, "Uspješno dodana oprema za automobil.",
              () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => CarDetailsScreen(car: widget.car)));
          });
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          MyDialogs.showError(context, e.toString());
        }
      }
    }
  }

  Container _buildCheckBox(String name, String title) {
    return Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        width: 230,
        child: FormBuilderCheckbox(
          initialValue: false,
          name: name,
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ));
  }
}
