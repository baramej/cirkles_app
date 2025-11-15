import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/home/home.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).home),
        centerTitle: true,
      ),
      body: const SizedBox(),
    );
  }
}
