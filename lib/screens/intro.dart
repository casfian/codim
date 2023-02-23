import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class Intro extends StatefulWidget {
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "WHAT IS OTTOMAP?",
        styleTitle: TextStyle(
            color: Colors.blue, fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "Easy to use land information data collection app. If you have a piece of land and you would like to have all the details about the perimeter, area size, crops, building and all physical features; whether it is man-made or natural, to be recorded and saved as a digital data online - then this is the app you need! Record, upload, store, share maps and data about your land for yourself, for others and for future generation with ease.",
        styleDescription: TextStyle(color: Colors.grey, fontSize: 20.0),
        pathImage: "assets/images/logo.png",
        backgroundColor: Colors.white, //0xfff5a623
      ),
    );
    slides.add(
      Slide(
        title: "CREATE A PLOT",
        styleTitle: TextStyle(
            color: Colors.orange, fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "Firstly, Walk and Add Point until you have all your land covered.",
        pathImage: "assets/images/logo.png",
        backgroundColor: Colors.grey,
      ),
    );
    slides.add(
      Slide(
        title: "EDIT PLOT",
        styleTitle: TextStyle(
            color: Colors.yellow, fontSize: 30.0, fontWeight: FontWeight.bold),
        description:
            "You can edit or add later additional information such as images or information",
        pathImage: "assets/images/logo.png",
        backgroundColor: Colors.blue[300],
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    print("End of slides");
    Navigator.pushNamed(context, '/plot');
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
