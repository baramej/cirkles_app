import 'package:fluffychat/pages/home/home_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeController();
}

class HomeController extends State<Home> {
  void navigateToChats() {
    context.go('/rooms');
  }

  void navigateToCircles() {
    context.go('/circles');
  }

  void navigateToMoments() {
    context.go('/moments');
  }

  void navigateToRoutes() {
    context.go('/routes');
  }

  void navigateToSettings() {
    context.go('/rooms/settings');
  }

  void navigateToNearby() {
    context.go('${GoRouter.of(context).routeInformationProvider.value.uri.path}/nearby');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Matrix.of(context).widget.emailValidation?.isEmailVerified == false) {
        context.go("/main/verifyEmail");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(controller: this);
  }
}
