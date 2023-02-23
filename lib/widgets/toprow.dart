import 'package:codimappp/screens/detailmap.dart';
import 'package:flutter/material.dart';

class TopRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(100, 115, 125, 0.1),
      ),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    '100',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text('Member Lands'),
                ],
              ),
              SizedBox(
                width: 130,
              ),
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailMap()));
                      },
                      child: Text(
                        '1',
                        style: TextStyle(fontSize: 40),
                      )),
                  Text(
                    'My Plots',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
