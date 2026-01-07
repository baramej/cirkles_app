import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/home/home.dart';
import 'package:fluffychat/pages/home/home_widgets.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matrix = Matrix.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Image.asset(
            'assets/appbar_icon.png',
            height: 50.0,
          ),
        ),
        title: Text(
          L10n.of(context).cirkles.toUpperCase(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          FutureBuilder<Profile>(
            future: matrix.client.isLogged() ? matrix.client.fetchOwnProfile() : null,
            builder: (context, snapshot) {
              return Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(99),
                color: Colors.transparent,
                child: Center(
                  child: Avatar(
                    onTap: controller.navigateToSettings,
                    mxContent: snapshot.data?.avatarUrl,
                    name: snapshot.data?.displayName ?? matrix.client.userID?.localpart,
                    size: 42,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          HomeContainer(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(HomeContainer.radius),
                  child: SizedBox(
                    height: 100.0,
                    child: Image.asset(
                      'assets/home_banner_transparent.png',
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: controller.navigateToNearby,
                    child: HomeContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.share_location,
                              color: theme.colorScheme.primary,
                              size: HomeButton.iconSize,
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    L10n.of(context).homeDiscoverNearby,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  Text(
                                    L10n.of(context).homeSeeWhosAround,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: AppColors.grey2,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Icon(
                              Icons.navigate_next,
                              color: theme.colorScheme.primary,
                              size: HomeButton.iconSize,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            primary: false,
            childAspectRatio: 1.4,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: [
              HomeButton(
                onTap: controller.navigateToChats,
                icon: Icons.chat,
                title: L10n.of(context).chats,
                subtitle: L10n.of(context).homeYourConversations,
              ),
              HomeButton(
                onTap: controller.navigateToCircles,
                icon: Icons.people,
                title: L10n.of(context).circles,
                subtitle: L10n.of(context).homeJoinNewGroups,
              ),
              HomeButton(
                onTap: controller.navigateToMoments,
                icon: Icons.camera,
                title: L10n.of(context).moments,
                subtitle: L10n.of(context).homeShareYourStories,
              ),
              HomeButton(
                onTap: controller.navigateToRoutes,
                icon: Icons.map,
                title: L10n.of(context).routes,
                subtitle: L10n.of(context).homeFindLocalPaths,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ListTile(
            onTap: () async {
              final url = Uri.parse("https://baramej.io");
              if (await canLaunchUrl(url)) {
                launchUrl(url);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(HomeContainer.radius),
            ),
            title: Text(
              L10n.of(context).poweredByBaramej,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
