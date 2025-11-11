import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/routes/routes.dart';
import 'package:flutter/material.dart';

class RoutesView extends StatelessWidget {
  const RoutesView({
    super.key,
    required this.controller,
  });

  final RoutesController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).routes),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Coming Soon!"),
      ),
    );
  }
}
