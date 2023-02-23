import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPlotDetails extends StatefulWidget {
  EditPlotDetails({Key? key, required this.docref}) : super(key: key);

  final String docref;

  @override
  State<EditPlotDetails> createState() => _EditPlotDetailsState();
}

class _EditPlotDetailsState extends State<EditPlotDetails> {
  var snapshot = FirebaseFirestore.instance.collection('plots');

  final _landownerController = TextEditingController();
  final _genderController = TextEditingController();
  final _contactnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void update(String landowner, String gender, String contactno) async {
      try {
        snapshot.doc(widget.docref).update(
          {
            'landowner': landowner,
            'gender': gender,
            'contactno': contactno
          });
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plot Details'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              TextField(controller: _landownerController,),
              TextField(controller: _genderController,),
              TextField(controller: _contactnoController,),
              ElevatedButton(
                  onPressed: () {
                    update(
                        _landownerController.text,
                        _genderController.text,
                        _contactnoController.text,
                        );
                    Navigator.pop(context);
                  },
                  child: Text('Edit'))
            ],
          ),
        ),
      ),
    );
  }
}
