import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'person/person_page.dart';
import 'setting/setting_page.dart';
import 'transaction/transaction_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;

  final screens = [
    const HomePage(),
    const TransactionPage(),
    const PersonPage(),
    const SettingPage(),
  ];

  final destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: "Beranda",
    ),
    const NavigationDestination(
      icon: Icon(Icons.handshake_outlined),
      selectedIcon: Icon(Icons.handshake),
      label: "Transaksi",
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: "Orang",
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: "Pengaturan",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() => _selectedIndex = value);
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(60.0),
      //   ),
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     context.pushNamed(formTransactionRoute);
      //   },
      // ),
    );
  }
}
