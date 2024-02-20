import 'package:flutter/material.dart';
import 'package:flutterg4_pis/views/sessionView.dart';
import 'package:flutterg4_pis/views/registroView.dart';
import 'package:flutterg4_pis/views/editarView.dart';
import 'package:flutterg4_pis/views/noticiasmapView.dart';
import 'package:flutterg4_pis/views/noticiasListView.dart';
import 'package:flutterg4_pis/views/mapView.dart';
import 'package:flutterg4_pis/views/mapamenuView.dart';
import 'package:flutterg4_pis/views/mainView.dart';
import 'package:flutterg4_pis/views/comentarioView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const RegistroView(),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const SessionView(),
        "/principal": (context) => const MainView(),
        "/nuevoUser": (context) => const RegistroView(),
        "/comentarios/nuevo": (context) => const ComentarioView(),
        "/maps/comentarios": (context) => const MapView(),
        "/usuarioConf": (context) => const EditarView(),
        "/noticias": (context) => const NoticiasListView(),
        "/maps": (context) => const MapaMenuView(),
        "/maps/noticias": (context) => const NoticiasMapView()
      },
    );
  }
}
