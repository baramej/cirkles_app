import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_circle/new_circle.dart';
import 'package:flutter/material.dart';

class NewCircleView extends StatelessWidget {
  const NewCircleView({
    super.key,
    required this.controller,
  });

  final NewCircleController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).newCircle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : controller.error != null
                ? Center(
                    child: Text(
                      controller.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : Form(
                    key: controller.newCircleFormKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: controller.nameController,
                          focusNode: controller.nameFocus,
                          autofocus: true,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? L10n.of(context).nameRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).name,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        FilledButton(
                          onPressed: controller.onSubmit,
                          child: Text(L10n.of(context).submit),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
