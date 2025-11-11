import 'package:fluffychat/pages/moments/moments_view.dart';
import 'package:flutter/material.dart';

class Moments extends StatefulWidget {
  const Moments({super.key});

  @override
  State<Moments> createState() => MomentsController();
}

class MomentsController extends State<Moments> {
  @override
  Widget build(BuildContext context) {
    return MomentsView(
      controller: this,
    );
  }
}
