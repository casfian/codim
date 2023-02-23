import 'package:codimappp/screens/detailmap.dart';
import 'package:codimappp/screens/home.dart';
import 'package:codimappp/model/user_location.dart';
import 'package:codimappp/screens/plot.dart';
import 'package:codimappp/screens/plotmap.dart';
import 'package:codimappp/screens/profile.dart';
import 'package:codimappp/screens/register.dart';
import 'package:codimappp/screens/viewmyplots.dart';
import 'package:codimappp/services/authentication.dart';
import 'package:codimappp/services/locationservice.dart';
import 'package:codimappp/screens/viewlandmap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Provider for Location
        StreamProvider<UserLocation>(
          initialData: UserLocation(
              latitude: 2.771999,
              longitude: 101.709989,
              accuracy: 5), //for the Plot Map location
          create: (context) => LocationService().locationStream,
        ),

        //Provider for Authentication
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: '',
        )
      ],
      child: MaterialApp(
        title: 'Codimappp',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: Home(),
        routes: <String, WidgetBuilder>{
          '/home': (context) => Home(),
          '/viewlandmap': (context) => ViewLandMap(),
          '/register': (context) => Register(),
          '/profile': (context) => Profile(),
          '/plot': (context) => Plot(),
          '/plotmap': (context) => PlotMap(),
          '/viewmyplots': (context) => ViewMyPlots(),
          '/detailmap': (context) => DetailMap(),
        },
      ),
    );
  }
}

