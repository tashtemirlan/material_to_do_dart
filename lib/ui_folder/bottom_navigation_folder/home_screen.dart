import 'package:flutter/material.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/skeleton_folder/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{

  bool dataGet = false;

  Future<void> initVoid() async{

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        color: colors.scaffoldColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          child: (dataGet)?
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ],
              )
            ],
          )
              :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(
                    width: 50,
                    height: 50,
                    style: SkeletonStyle.circle,
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          AppLocalizations.of(context)!.welcome_message_home,
                          style: TextStyle(
                            fontSize: 18, color: colors.black1, fontWeight: FontWeight.w600,
                          )
                      ),
                      const SizedBox(height: 5,),
                      Skeleton(
                        width: 50,
                        height: 18,
                        style: SkeletonStyle.text,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Skeleton(
                width: width,
                borderRadius: BorderRadius.circular(30),
                height: 100,
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!.in_progress_text,
                      style: TextStyle(
                        fontSize: 18, color: colors.black1, fontWeight: FontWeight.w600,
                      )
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: colors.shimmerColor,
                        shape: BoxShape.circle
                    ),
                    child: Text(
                        "99",
                        style: TextStyle(
                          fontSize: 16, color: colors.mainColor, fontWeight: FontWeight.w600,
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Skeleton(
                      width: width*0.75,
                      height: 150,
                      style: SkeletonStyle.box,
                    );
                  }
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!.task_groups_text,
                      style: TextStyle(
                        fontSize: 18, color: colors.black1, fontWeight: FontWeight.w600,
                      )
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: colors.shimmerColor,
                        shape: BoxShape.circle
                    ),
                    child: Text(
                        "9",
                        style: TextStyle(
                          fontSize: 16, color: colors.mainColor, fontWeight: FontWeight.w600,
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 15,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Skeleton(
                      width: width*0.9,
                      height: 100,
                      style: SkeletonStyle.box,
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}