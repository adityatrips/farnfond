import 'package:farnfond/core/map_component.dart';
import 'package:farnfond/screens/chat_screen.dart';
import 'package:farnfond/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: key,
        drawer: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                height: 200,
                width: double.maxFinite,
                child: Center(
                  child: Text(
                    "Far n' Fond",
                    style: Theme.of(context).textTheme.headlineMedium!,
                  ),
                ),
              ),
              const ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home_rounded),
              ),
              const ListTile(
                title: Text("Profile"),
                leading: Icon(Icons.person_rounded),
              ),
              const ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.settings_rounded),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              key.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu_rounded),
          ),
          title: Text(
            "Welcome home",
            style: Theme.of(context).textTheme.headlineMedium!,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: SafeArea(
          child: SlidingUpPanel(
            color: Theme.of(context).scaffoldBackgroundColor,
            backdropEnabled: true,
            backdropColor: Colors.black12,
            backdropTapClosesPanel: true,
            parallaxEnabled: true,
            parallaxOffset: .5,
            minHeight: 76,
            panel: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => const ChatScreen());
                    },
                    style: iconBtnStyle(),
                    icon: const Icon(
                      Icons.chat_bubble_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    style: iconBtnStyle(),
                    icon: const Icon(
                      Icons.phone_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    style: iconBtnStyle(),
                    icon: const Icon(
                      Icons.video_call_rounded,
                    ),
                  ),
                ],
              ),
            ),
            body: const MapComponent(),
          ),
        ),
      ),
    );
  }

  ButtonStyle iconBtnStyle() {
    return IconButton.styleFrom(
      backgroundColor: Theme.of(Get.context!).colorScheme.primary,
      foregroundColor: Theme.of(Get.context!).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      fixedSize: const Size.square(60),
    );
  }
}
