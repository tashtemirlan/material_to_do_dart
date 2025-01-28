import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/bottom_navigation_folder/bottom_navigation_screen.dart';


class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  CreateTaskScreenState createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen>{


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create task"),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => const BottomNavBar(),
                ));
              },
              child: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black, size: 18,),
            )
          ],
        ),
      ),
    );
  }
}