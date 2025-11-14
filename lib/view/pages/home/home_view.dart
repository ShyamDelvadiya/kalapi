import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_pg/main.dart';
import 'package:my_pg/routing/route_name.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Clear login pref and go to login
              try {
                pref.write('isLoggedIn', false);
              } catch (_) {}
              Get.offAllNamed(RouteName.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Welcome to Farshan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'This is a simple home dashboard placeholder. Replace with your app content.',
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                subtitle: const Text('Tap to view profile'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
