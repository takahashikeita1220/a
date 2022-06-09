import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:collection';

void main() {
  initializeDateFormatting().then((_) =>runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const TopPage(title: 'Calendar'),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Map<DateTime, List> _eventsList = {};
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  int getHashCode(DateTime key){
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState(){
    super.initState();

    _selected = _focused;
    _eventsList = {
      DateTime.now().subtract(const Duration(days: 2)): ['Event A6', 'Event B6'],
      DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      DateTime.now().add(const Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      DateTime.now().add(const Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      DateTime.now().add(const Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      DateTime.now().add(const Duration(days: 11)): ['Event A11', 'Event B11'],
      DateTime.now().add(const Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      DateTime.now().add(const Duration(days: 22)): ['Event A13', 'Event B13'],
      DateTime.now().add(const Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };
  }

  @override
  Widget build(BuildContext context) {

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEvent(DateTime day){
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'ja',
              firstDay: DateTime.utc(2022, 4, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              eventLoader: getEvent,
              selectedDayPredicate: (day){
                return isSameDay(_selected, day);
              },
              onDaySelected: (selected, focused){
                if (!isSameDay(_selected, selected)){
                  setState(() {
                    _selected = selected;
                    _focused = focused;
                  });
                }
              },
              focusedDay: _focused,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format){
                if (_calendarFormat != format){
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events){
                  if (events.isNotEmpty){
                    return _buildEventsMarker(date, events);
                  }
                },
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: Colors.red, 
                ),
              ),
              calendarStyle: const CalendarStyle(
                weekendTextStyle: TextStyle(
                  color: Colors.red, 
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: getEvent(_selected!)
                  .map((event) => ListTile(
                        title: Text(event.toString()),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildEventsMarker(DateTime date, List events) {
  return Positioned(
    right: 5,
    bottom: 5,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red[300],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}