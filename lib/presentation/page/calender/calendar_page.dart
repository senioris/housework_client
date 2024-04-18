import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now();
    final month = useState(now);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${DateFormat(DateFormat.MONTH).format(month.value)} ${DateFormat(DateFormat.YEAR).format(month.value)}"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            month.value = DateTime(month.value.year, month.value.month - 1);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () {
              if ((month.value.year == now.year &&
                      month.value.month < now.month) ||
                  (month.value.year < now.year)) {
                month.value = DateTime(month.value.year, month.value.month + 1);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.check),
      )
    );
  }
}
