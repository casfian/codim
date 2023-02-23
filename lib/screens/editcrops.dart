import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCrops extends StatefulWidget {
  EditCrops({Key? key, required this.docref}) : super(key: key);

  final String docref;

  @override
  State<EditCrops> createState() => _EditCropsState();
}

class _EditCropsState extends State<EditCrops> {
  var snapshot = FirebaseFirestore.instance.collection('plots');

  //final _cropController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // void update(List crop) async {
    //   try {
    //     snapshot.doc(widget.docref).update({'cropdata': crop});
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Crops'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile();
        },)
    );
  }
}
