// ignore_for_file: prefer_const_constructors

import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "CAR DETAILS",
      child: Text("Details..."),
    );
  }
}
