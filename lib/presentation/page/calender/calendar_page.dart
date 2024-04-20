import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

const MAX_WEEK = 2 * 53;

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
        children: [WeekCalendar(focusDay: day)],
      ),
    );
  }
}

class WeekCalendar extends HookConsumerWidget {
  WeekCalendar({
    super.key,
    required this.focusDay,
  });

  final ValueNotifier<DateTime> focusDay;
  final PageController _pageController = PageController(
    initialPage: MAX_WEEK,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 110)
    , child: PageView.builder(
        itemCount: MAX_WEEK,
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        itemBuilder: (context, index) {
          focusDay.value = focusDay.value.subtract(const Duration(days:7));
          return WeekView(
            startDay: _getSunday(focusDay.value),
            focusDay: focusDay,
          );
        }),
    );
  }

  DateTime _getSunday(DateTime date) {
    return date.subtract(Duration(days: date.weekday == 7 ? 0 : date.weekday));
  }

  DateTime _getMonday(DateTime date) {
    return date
        .subtract(Duration(days: date.weekday == 1 ? 0 : date.weekday - 1));
  }
}

class WeekView extends StatelessWidget {
  const WeekView({
    super.key,
    required this.startDay,
    required this.focusDay,
  });

  final DateTime startDay;
  final ValueNotifier<DateTime> focusDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: DayView(
                      day: startDay.add(Duration(days: i)),
                      focusDay: focusDay)),
            ),
        ],
      ),
    );
  }
}

class DayView extends StatelessWidget {
  const DayView({
    super.key,
    required this.day,
    required this.focusDay,
  });

  final DateTime day;
  final ValueNotifier<DateTime> focusDay;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: day == focusDay.value
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 223, 217, 217),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ])
            : null,
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onTap: () => focusDay.value = day,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(DateFormat(DateFormat.ABBR_WEEKDAY).format(day),
                  style: TextStyle(
                    color: day.weekday == DateTime.sunday
                        ? Colors.red
                        : day.weekday == DateTime.saturday
                            ? Colors.blue
                            : Colors.black,
                  )),
              const SizedBox(
                height: 5,
              ),
              Text(DateFormat(DateFormat.DAY).format(day),
                  style: TextStyle(
                    color: day.weekday == DateTime.sunday
                        ? Colors.red
                        : day.weekday == DateTime.saturday
                            ? Colors.blue
                            : Colors.black,
                  )),
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
        ));
  }
}
