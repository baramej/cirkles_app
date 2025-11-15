import 'package:fluffychat/pages/home/home_view.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeController();
}

class HomeController extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return HomeView(controller: this);
  }
}
