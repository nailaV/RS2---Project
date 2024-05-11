import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';

class DetaljiProizvoda extends StatefulWidget {
  const DetaljiProizvoda({super.key});

  @override
  State<DetaljiProizvoda> createState() => _DetaljiProizvodaState();
}

class _DetaljiProizvodaState extends State<DetaljiProizvoda> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Detalji proizvoda",
      child: Text("aaa"),
    );
  }
}
