import 'dart:io';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_route/new_route_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewRoute extends StatefulWidget {
  const NewRoute({super.key});

  @override
  State<NewRoute> createState() => NewRouteController();
}

class NewRouteController extends State<NewRoute> {
  final imagePicker = ImagePicker();
  final newRouteFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final kmsController = TextEditingController();
  final urlController = TextEditingController();

  bool loading = true;
  String? error;
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;
  XFile? image;
  List<Map<String, dynamic>> experiences = [];
  List<int> selectedExperiences = [];

  void selectExperience(int id) {
    setState(() {
      selectedExperiences.add(id);
    });
  }

  void unselectExperience(int id) {
    setState(() {
      selectedExperiences.remove(id);
    });
  }

  Future<void> pickImage() async {
    final result = await imagePicker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        image = result;
      });
    }
  }

  void setCategory(Map<String, dynamic>? value) {
    setState(() {
      selectedCategory = value;
    });
  }

  Future<void> initData() async {
    await Future.wait([
      loadCategories(),
      loadExperiences(),
    ]);

    setState(() {
      loading = false;
      error = null;
    });
  }

  Future<void> loadCategories() async {
    final response = await Supabase.instance.client.from('route_category').select();
    setState(() {
      categories = response;
      if (response.isNotEmpty) {
        selectedCategory = response.first;
      }
    });
  }

  Future<void> loadExperiences() async {
    final response = await Supabase.instance.client.from('route_experience').select();
    setState(() {
      experiences = response;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  Future<void> submit() async {
    if (newRouteFormKey.currentState!.validate()) {
      final duration = int.tryParse(durationController.text);
      final kms = int.tryParse(kmsController.text);

      if (duration == null || kms == null) {
        return;
      }

      setState(() {
        loading = true;
      });

      final l10n = L10n.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        final imagePath = "images/${image!.name}";
        await Supabase.instance.client.storage.from('route').upload(
              imagePath,
              File(image!.path),
              fileOptions: const FileOptions(
                upsert: true,
              ),
            );

        final imageUrl = Supabase.instance.client.storage.from('route').getPublicUrl(imagePath);

        final response = await Supabase.instance.client.from('route').insert({
          "name": nameController.text.trim(),
          "description": descriptionController.text.trim(),
          "duration": duration,
          "kms": kms,
          "url": urlController.text.trim(),
          "category_id": selectedCategory!['id'],
          "image": imageUrl,
        }).select();

        for (var i = 0; i < selectedExperiences.length; i++) {
          await Supabase.instance.client.from('route_route_experience').insert({
            "route_id": response[0]['id'],
            "experience_id": selectedExperiences[i],
          });
        }

        setState(() {
          loading = false;
          error = null;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.newRouteSuccess),
            ),
          );
          context.pop(true);
        });
      } catch (err) {
        setState(() {
          loading = false;
          error = l10n.newRouteError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NewRouteView(controller: this);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    kmsController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
