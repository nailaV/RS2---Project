// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:eautokuca_desktop/models/recenzije.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/recenzije_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecenzijeScreen extends StatefulWidget {
  const RecenzijeScreen({super.key});

  @override
  State<RecenzijeScreen> createState() => _RecenzijeScreenState();
}

class _RecenzijeScreenState extends State<RecenzijeScreen> {
  late RecenzijeProvider _recenzijeProvider;

  bool isLoading = true;
  SearchResult<Recenzije>? recenzijeData;

  @override
  void initState() {
    super.initState();
    _recenzijeProvider = context.read<RecenzijeProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Recenzije",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 6 / 3,
                ),
                itemCount: recenzijeData?.result.length ?? 0,
                itemBuilder: (context, index) {
                  var review = recenzijeData!.result[index];
                  return buildRes(review);
                },
              ),
            ),
    );
  }

  Widget buildRes(Recenzije review) {
    var user = review.korisnik;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (user != null &&
                    user.slika != null &&
                    user.slika!.isNotEmpty)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(base64Decode(user.slika!)),
                  )
                else
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.account_circle,
                        size: 34, color: Colors.white),
                  ),
                SizedBox(width: 8),
                if (user != null)
                  Text(
                    user.ime ?? 'Unknown.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              review.sadrzaj ?? 'Nema sadržaja.',
              style: TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < (review.ocjena ?? 0) ? Icons.star : Icons.star_border,
                  color: Colors.yellow[700],
                  size: 20,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    try {
      var data = await _recenzijeProvider.getAll();
      setState(() {
        recenzijeData = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
