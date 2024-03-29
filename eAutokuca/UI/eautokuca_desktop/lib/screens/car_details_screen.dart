// ignore_for_file: prefer_const_constructors, use_super_parameters, must_be_immutable

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
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
    _initialValue = {"motor": widget.car?.motor};
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
      title: this.widget.car?.automobilId.toString() ?? "Detalji",
      child: _buildForm(),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: FormBuilderTextField(name: "motor"),
    );
  }
}
