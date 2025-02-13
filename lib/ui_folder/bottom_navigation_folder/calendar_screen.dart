import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;

import '../../global_folder/globals.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen>{

  late DateTime selectedDateTime;

  void showCupertinoDatePicker() async{
    final resultPicker = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('QQQQQQ', style: TextStyle(color: CupertinoColors.activeBlue)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text('WWWWWWW', style: TextStyle(color: CupertinoColors.activeBlue)),
                    onPressed: () {
                      Navigator.pop(context, selectedDateTime);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: selectedDateTime,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDateTime = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if(resultPicker!=null){
      setState(() {
        selectedDateTime = resultPicker;
      });
    }
  }

  Future<void> initVoid() async{
    selectedDateTime = DateTime.now();
  }

  Widget tasks() {
    return Column(
      children: List.generate(
        100, (index) => Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: double.infinity,
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initVoid();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
          width: width,
          height: height,
          color: colors.scaffoldColor,
          child: Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Text("Сегодня $selectedDateTime"),
                        GestureDetector(
                          onTap: showCupertinoDatePicker,
                          child: Icon(FontAwesomeIcons.calendar, color: colors.mainColor, size: 18,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 40,
                            color: Colors.blue.shade100,
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: 200,
                            height: 40,
                            color: Colors.blue.shade200,
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: 200,
                            height: 40,
                            color: Colors.blue.shade300,
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: 200,
                            height: 40,
                            color: Colors.blue.shade400,
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            width: 200,
                            height: 40,
                            color: Colors.blue.shade500,
                          ),
                        ],
                      ),
                    ),
                    Text("Задачи на сегодня"),
                    const SizedBox(height: 10,),
                    tasks()
                  ],
                ),
              ),
            ),
          )
      )
    );
  }
}