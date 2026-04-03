import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'providers/expense_provider.dart';
import 'providers/receivable_provider.dart';
import 'providers/staff_provider.dart';
import 'screens/expenses_screen.dart';
import 'screens/home_screen.dart';
import 'screens/receivables_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/staff_screen.dart';

void main() {
  runApp(const HisaabProApp());
}

class HisaabProApp extends StatelessWidget {
  const HisaabProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ReceivableProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
      ],
      child: MaterialApp(
        title: 'HisaabPro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigator(),
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ExpensesScreen(),
    ReceivablesScreen(),
    StaffScreen(),
    SettingsScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'Expenses',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_outline),
      activeIcon: Icon(Icons.people),
      label: 'Receivables',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.badge_outlined),
      activeIcon: Icon(Icons.badge),
      label: 'Staff',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}
