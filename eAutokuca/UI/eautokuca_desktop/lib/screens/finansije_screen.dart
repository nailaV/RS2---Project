// ignore_for_file: prefer_const_constructors

import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';

class FinansijeScreen extends StatefulWidget {
  const FinansijeScreen({super.key});

  @override
  State<FinansijeScreen> createState() => _FinansijeScreenState();
}

class _FinansijeScreenState extends State<FinansijeScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "FINANSIJE",
        child: Container(
            child: Column(
          children: [Text("finansije")],
        )));
  }
}
