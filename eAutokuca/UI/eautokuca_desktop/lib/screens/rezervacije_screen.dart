import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({super.key});

  @override
  State<RezervacijeScreen> createState() => _RezervacijeScreenState();
}

class _RezervacijeScreenState extends State<RezervacijeScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "REZERVACIJE",
        child: Container(
            child: Column(
          children: [Text("data")],
        )));
  }
}
