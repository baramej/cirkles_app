import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/moments/moments.dart';
import 'package:flutter/material.dart';

class MomentsView extends StatelessWidget {
  const MomentsView({
    super.key,
    required this.controller,
  });

  final MomentsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).moments),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Coming Soon!"),
      ),
    );
  }
}
