import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRemark extends StatefulWidget {
  EditRemark({Key? key, required this.docref}) : super(key: key);

  final String docref;

  @override
  State<EditRemark> createState() => _EditRemarkState();
}

class _EditRemarkState extends State<EditRemark> {
  var snapshot = FirebaseFirestore.instance.collection('plots');

  final _remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void update(String remark) async {
      try {
        snapshot.doc(widget.docref).update({'remark': remark});
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Remark'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              TextField(controller: _remarkController,),
              ElevatedButton(
                  onPressed: () {
                    update(
                        _remarkController.text,
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
