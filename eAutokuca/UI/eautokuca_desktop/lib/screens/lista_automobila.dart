import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListaAutomobila extends StatefulWidget {
  const ListaAutomobila({super.key});

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text('TestTest'),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Go back'))
      ],
    ));
  }
}
