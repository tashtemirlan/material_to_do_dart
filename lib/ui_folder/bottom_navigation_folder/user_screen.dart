import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../start_folder/sign_up_folder/policy_screen.dart';
import '../start_folder/sign_up_folder/privacy_screen.dart';
import '../user/user_change_avatar_bottom_sheet.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen>{

  TextEditingController nameController = TextEditingController();

  Future<void> logoutUser () async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          title: Text(
              AppLocalizations.of(context)!.user_screen_logout_alert_title , textAlign: TextAlign.center,
              style: GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 24, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              ))
          ),
          content: Text(
              AppLocalizations.of(context)!.user_screen_logout_alert_subtitle ,  textAlign: TextAlign.start,
              style:  GoogleFonts.roboto(textStyle: TextStyle(
                  fontSize: 14, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              ))
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: ()async{
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        child: Text(
                            AppLocalizations.of(context)!.no_string,
                            style: TextStyle(
                                fontSize: 14, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
                            )
                        ),
                      )
                  ),
                  const SizedBox(width: 8,),
                  TextButton(
                      onPressed: () async{
                        print("logout action");
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        child: Text(
                            AppLocalizations.of(context)!.yes_string,
                            style: GoogleFonts.roboto(textStyle:  TextStyle(
                                fontSize: 14, color: colors.errorTextFormFieldColor, fontWeight: FontWeight.w500 , letterSpacing: 0.1
                            ))
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget chevronSelectContainer(
      {
        required double width,
        Color? colorBorder,
        required String? textMain,
        Color? colorText,
      }
      )
  {
    return Container(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: colorBorder ?? Colors.black
          )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(textMain ?? "",
              style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: 16,
                color: colorText ?? Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500
              ),
            )),
            FaIcon(FontAwesomeIcons.chevronRight, color: colorBorder ?? Colors.black, size: 18,)
          ],
        ),
      ),
    );
  }

  void showUserBottomSheetData(){
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: false,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return Padding(
            padding: EdgeInsets.symmetric(vertical : 10, horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  width: width,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 24,
                        child: Icon(FontAwesomeIcons.xmark, size: 24, color: Colors.black, weight: 2,),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade500
                  ),
                ),
                const SizedBox(height: 15,),
                Text(
                  "User name here",
                  style: GoogleFonts.roboto( textStyle: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600
                  )),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    changeUserNameBottomSheet("Person");
                  },
                  child: chevronSelectContainer(
                      width: width,
                      textMain: AppLocalizations.of(context)!.change_user_name_string),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    changeUserImageBottomSheet("https://static.wikia.nocookie.net/kimetsu-no-yaiba/images/0/08/Yoriichi_Tsugikuni_%28Anime%29.png/revision/latest?cb=20230411022113");
                  },
                  child: chevronSelectContainer(
                      width: width,
                      textMain: AppLocalizations.of(context)!.change_user_image_string),
                ),
              ],
            ),
        );
      },
    );
  }

  Widget editUserName(String? userName, double width, bool editBool, Function setState){
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                borderRadius: BorderRadius.circular(20)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.errorTextFormFieldColor),
                borderRadius: BorderRadius.circular(20)
            ),
            contentPadding: const EdgeInsets.only(left: 24, right: 18, top: 20, bottom: 20),
            hintStyle: TextStyle(fontSize: 16 , color: colors.weightColor, fontWeight: FontWeight.w500),
            hintText: AppLocalizations.of(context)!.hint_name_string,
            fillColor: Colors.white,
            filled: true,
            errorStyle: const TextStyle(
              fontSize: 0,
            ),
            errorMaxLines: 1,
            suffixIcon: (nameController.text.isEmpty)? const SizedBox() : (editBool)?
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.solidCircleCheck, color: colors.circleCheckColor, size: 24,),)
                :
            Padding(padding: const EdgeInsets.only(top: 10), child: FaIcon(FontAwesomeIcons.circleExclamation, color: colors.errorTextFormFieldColor, size: 24,),)
        ),
        style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack)),
        validator: (String?value){
          if(value!.length < 2){
            return "";
          }
          return null;
        },
        onChanged: (val){
          if(val.length<2){
            setState(() {
              editBool = false;
            });
          }
          else{
            setState(() {
              editBool = true;
            });
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(99),
        ],
      ),
    );
  }

  Widget buttonEditNameApply(double width){
    return SizedBox(
        width: width,
        child: ElevatedButton(
            onPressed: () async{
              print("updated data for user name");
            },
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                backgroundColor: (nameController.text.length>=2)?
                WidgetStateProperty.all<Color>(colors.mainColor)
                    :
                WidgetStateProperty.all<Color>(colors.mainColor.withOpacity(0.3))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                  AppLocalizations.of(context)!.save_string,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600 , letterSpacing: 0.01
                  ))),
            )
        )
    );
  }

  void changeUserNameBottomSheet(String userName){
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: false,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        nameController.text = userName;
        return StatefulBuilder(
            builder: (context, setState){
              bool nameBool = nameController.text.length >= 2;
              return Padding(
                padding: EdgeInsets.symmetric(vertical : 10, horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.change_user_name_string,
                            style: GoogleFonts.roboto(textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                letterSpacing: 0.01,
                                decoration: TextDecoration.none
                            )),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              radius: 20,
                              child: Icon(FontAwesomeIcons.xmark, size: 24, color: Colors.black, weight: 2,),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Material(
                      child: editUserName(userName, width, nameBool, setState),
                    ),
                    const SizedBox(height: 20,),
                    buttonEditNameApply(width)
                  ],
                ),
              );
            }
        );
      },
    );
  }

  void changeUserImageBottomSheet(String imagePath) {
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: true,
      builder: (BuildContext context) {
        return UserChangeAvatarBottomSheet(imagePath: imagePath,);
      },
    );
  }

  void showPolicyAndPrivacyBottomSheetData(){
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: false,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.user_screen_policy_and_privacy,
                        style: GoogleFonts.roboto(textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            letterSpacing: 0.01,
                            decoration: TextDecoration.none
                        )),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 20,
                          child: Icon(FontAwesomeIcons.xmark, size: 24, color: Colors.black, weight: 2,),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => const PolicyScreen(),
                    ));
                  },
                  child: Container(
                    width: width*0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.policy_string,
                          style: GoogleFonts.roboto( textStyle: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black, fontSize: 16,
                              fontWeight: FontWeight.w500
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (BuildContext context) => const PrivacyScreen(),
                    ));
                  },
                  child: Container(
                    width: width*0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.privacy_string,
                          style: GoogleFonts.roboto(textStyle: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black, fontSize: 16,
                              fontWeight: FontWeight.w500
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
              ],
            ),
        );
      },
    );
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
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15,),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade500
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text("User name here", style: GoogleFonts.roboto(textStyle: TextStyle()),),
                    const SizedBox(height: 30,),
                    GestureDetector(
                      onTap: showUserBottomSheetData,
                      child: chevronSelectContainer(
                          width: width,
                          textMain: AppLocalizations.of(context)!.user_screen_view_profile
                      ),
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: showPolicyAndPrivacyBottomSheetData,
                      child: chevronSelectContainer(
                          width: width,
                          textMain: AppLocalizations.of(context)!.user_screen_policy_and_privacy
                      ),
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () async{
                        await logoutUser();
                      },
                      child: chevronSelectContainer(
                          width: width,
                          textMain: AppLocalizations.of(context)!.user_screen_logout,
                          colorBorder: Colors.red.shade300,
                          colorText: Colors.red.shade500
                      ),
                    ),
                  ],
                ),
              ),
            ),
        )
      ),
    );
  }
}