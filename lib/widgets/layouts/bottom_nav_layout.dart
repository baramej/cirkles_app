import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'two_column_layout.dart';

class BottomNavLayout extends StatefulWidget {
  const BottomNavLayout({
    super.key,
    required this.state,
    required this.shell,
  });

  final GoRouterState state;
  final StatefulNavigationShell shell;

  @override
  State<BottomNavLayout> createState() => _BottomNavLayoutState();
}

class _BottomNavLayoutState extends State<BottomNavLayout> {
  StatefulNavigationShell get shell => widget.shell;
  GoRouterState get state => widget.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: shell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: L10n.of(context).home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat),
            label: L10n.of(context).chats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.circle_outlined),
            label: L10n.of(context).circles,
          ),
          NavigationDestination(
            icon: const Icon(Icons.music_note),
            label: L10n.of(context).moments,
          ),
          NavigationDestination(
            icon: const Icon(Icons.navigation),
            label: L10n.of(context).routes,
          ),
        ],
      ),
      body: FluffyThemes.isColumnMode(context) && state.fullPath?.startsWith('/rooms/settings') == false
          ? TwoColumnLayout(
              mainView: ChatList(
                activeChat: state.pathParameters['roomid'],
                displayNavigationRail: state.path?.startsWith('/rooms/settings') != true,
              ),
              sideView: shell,
            )
          : shell,
    );
  }
}
