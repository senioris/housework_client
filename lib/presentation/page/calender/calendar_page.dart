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
    final day = useState(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${DateFormat(DateFormat.MONTH).format(month.value)} ${DateFormat(DateFormat.YEAR).format(month.value)}"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            month.value = DateTime(month.value.year, month.value.month - 1);
            day.value = DateTime(month.value.year, month.value.month, 1);
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
                day.value = DateTime(month.value.year, month.value.month, 1);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.check),
      ),
      body: Column(
        children: [WeekCalendar(day: day)],
      ),
    );
  }
}

class WeekCalendar extends HookConsumerWidget {
  const WeekCalendar({
    super.key,
    required this.day,
  });

  final ValueNotifier<DateTime> day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var startDay = _getSunday(day.value);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                  decoration: i == 0
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 223, 217, 217),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ])
                      : null,
                  child: DayView(day: startDay.add(Duration(days: i)))),
            )),
        ],
      ),
    );
  }

  DateTime _getSunday(DateTime date) {
    return date.subtract(Duration(days: date.weekday));
  }
}

class DayView extends HookConsumerWidget {
  const DayView({
    super.key,
    required this.day,
  });

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onTap: () => {},
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            DateFormat(DateFormat.ABBR_WEEKDAY).format(day),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            DateFormat(DateFormat.DAY).format(day),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0xd4, 0xfd, 0xa2, 1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
