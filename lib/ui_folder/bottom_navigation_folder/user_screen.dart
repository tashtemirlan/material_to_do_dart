import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/skeleton_folder/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen>{


  Future<void> logoutUser () async{

  }

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        color: colors.scaffoldColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade500
                  ),
                ),
                const SizedBox(height: 15,),
                Text("Blablalalalllalalalal"),
                const SizedBox(height: 10,),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Very very very"),
                        FaIcon(FontAwesomeIcons.chevronRight, color: Colors.black, size: 18,)
                      ],
                    ),  
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () async{
                    await logoutUser();
                  },
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.red
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Logout", style: TextStyle(color: Colors.red),),
                          FaIcon(FontAwesomeIcons.chevronRight, color: Colors.red, size: 18,)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}