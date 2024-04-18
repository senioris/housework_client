import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:houseworks/presentation/page/calender/calendar_page.dart';

final currentIndexProvider = StateProvider<int>((_) => IndexMode.calendar.index);

/// インデックスモード
enum IndexMode {
  /// カレンダー（デフォルト）
  calendar,
  graph,
  add,
  notification,
  setting
}

class HomePage extends HookConsumerWidget {
  final List<Widget> _children = [
    const CalendarPage(),
    const CalendarPage(),
    const CalendarPage(),
    const CalendarPage(),
    const CalendarPage(),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(currentIndexProvider);
    return Scaffold(
      body: _children[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          ref.watch(currentIndexProvider.notifier).state = index
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
