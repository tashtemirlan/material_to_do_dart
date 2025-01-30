import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/ui_folder/skeleton_folder/skeleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
              style: TextStyle(
                  fontSize: 24, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              )
          ),
          content: Text(
              AppLocalizations.of(context)!.user_screen_logout_alert_subtitle ,  textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14, color: colors.darkBlack, fontWeight: FontWeight.w500 , letterSpacing: 0.1
              )
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
                            style: TextStyle(
                                fontSize: 14, color: colors.errorTextFormFieldColor, fontWeight: FontWeight.w500 , letterSpacing: 0.1
                            )
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
              style: TextStyle(
                fontSize: 16,
                color: colorText ?? Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w500
              ),
            ),
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
                  style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600
                  ),
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
        style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w600 , color: colors.darkBlack),
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
                  style: const TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600 , letterSpacing: 0.01
                  )),
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
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                letterSpacing: 0.01,
                                decoration: TextDecoration.none
                            ),
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

  // TODO : write as a stateful widget this and take as a child inside model bottom sheet = >

  Future<void> _pickImages(
      Function setState,
      ValueSetter<XFile?> onImageSelected,
      ValueSetter<FileImage?> onImageDisplay
      ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File userSelectedFile = File(pickedFile.path);
      if (userSelectedFile.lengthSync() <= 12 * 1024 * 1024) {
        setState(() {
          onImageSelected(pickedFile); // Updates XFile variable
          onImageDisplay(FileImage(userSelectedFile)); // Updates FileImage for UI
        });
        print("User successfully selected an image");
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.not_choosen_image,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 12.0,
      );
    }
  }

  Widget showChoseImage(width, userChooseImage) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InstaImageViewer(child: Image(image: userChooseImage, fit: BoxFit.cover,)),
      ),
    );
  }

  Widget uploadImagesContainer(
      double width,
      double height,
      XFile? imageFile,
      FileImage? userChooseImage,
      Function setState
      ) {
    return GestureDetector(
      onTap: () {
        _pickImages(
          setState,
              (XFile? newFile) {
            setState(() {
              imageFile = newFile;
            });
          },
              (FileImage? newImage) {
            setState(() {
              userChooseImage = newImage;
            });
          },
        );
      },
      child: imageFile != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          File(imageFile.path),
          width: width * 0.95,
          height: height * 0.4,
          fit: BoxFit.cover,
        ),
      )
          : Container(
        width: width * 0.95,
        height: height * 0.4,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 245, 245, 1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color.fromRGBO(221, 221, 221, 1),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.cameraRetro,
                color: Color.fromRGBO(77, 170, 232, 1),
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.add_image_string,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.max_capacity_image_string,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromRGBO(154, 154, 154, 1),
                  fontSize: 12,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeUserImageBottomSheet(String imagePath) {
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: true,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return StatefulBuilder(
          builder: (context, setState) {
            XFile? imageFile;
            FileImage? userChooseImage;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.change_user_image_string,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              letterSpacing: 0.01,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              radius: 20,
                              child: const Icon(
                                FontAwesomeIcons.xmark,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, downloadProgress){
                          return Center(
                            child: Container(
                              width: width,
                              height: height/3,
                              color: Colors.grey.shade200,
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        imageUrl: imagePath,
                        imageBuilder: (context, imageProvider){
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: InstaImageViewer(child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),),
                          );
                        },
                        errorWidget: (context, url, error) => Skeleton(
                          width: width,
                          height: height/3,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    uploadImagesContainer(width, height, imageFile, userChooseImage, setState)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //End of TODO :

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
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            letterSpacing: 0.01,
                            decoration: TextDecoration.none
                        ),
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
                  onTap: viewPolicyBottomSheet,
                  child: Container(
                    width: width*0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
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
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black, fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: viewPrivacyBottomSheet,
                  child: Container(
                    width: width*0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
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
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black, fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
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

  void viewPolicyBottomSheet(){
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.policy_string,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black, fontSize: 24,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 15,),
                Text(
                  AppLocalizations.of(context)!.policy_generated_string,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black, fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void viewPrivacyBottomSheet(){
    showCupertinoModalBottomSheet<bool>(
      topRadius: const Radius.circular(40),
      backgroundColor: colors.scaffoldColor,
      context: context,
      expand: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.privacy_string,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black, fontSize: 24,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 15,),
                Text(
                  AppLocalizations.of(context)!.privacy_generated_string,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black, fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
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
                Text("User name here"),
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
      ),
    );
  }
}