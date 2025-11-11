import 'package:fluffychat/pages/routes/routes_view.dart';
import 'package:flutter/material.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => RoutesController();
}

class RoutesController extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return RoutesView(controller: this);
  }
}
