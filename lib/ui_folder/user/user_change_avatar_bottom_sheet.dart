import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

import '../skeleton_folder/skeleton.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;



class UserChangeAvatarBottomSheet extends StatefulWidget {
  final String imagePath;
  const UserChangeAvatarBottomSheet({super.key, required this.imagePath});

  @override
  UserChangeAvatarBottomSheetState createState() => UserChangeAvatarBottomSheetState();
}

class UserChangeAvatarBottomSheetState extends State<UserChangeAvatarBottomSheet>{

  XFile? imageFile;
  FileImage? userChooseImage;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File userSelectedFile = File(pickedFile.path);
      if (userSelectedFile.lengthSync() <= 12 * 1024 * 1024) {
        setState(() {
          imageFile = XFile(pickedFile.path);
          userChooseImage = FileImage(userSelectedFile);
        });
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

  Widget uploadImagesContainer(double width, double height) {
    return GestureDetector(
      onTap: () {
        _pickImages();
      },
      child: imageFile != null
          ? Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              File(imageFile!.path),
              width: width * 0.95,
              height: height * 0.4,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imageFile = null;
                  userChooseImage = null;
                });
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.6),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
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
                style: GoogleFonts.roboto(textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                )),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.max_capacity_image_string,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(textStyle:  const TextStyle(
                  color: Color.fromRGBO(154, 154, 154, 1),
                  fontSize: 12,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonLogin(width){
    return SizedBox(
        width: width,
        child: ElevatedButton(
            onPressed: () async{
              if(userChooseImage!=null){
                print("update image");
              }
              else{
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(colors.mainColor)
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


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    style: GoogleFonts.roboto(textStyle:  const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      letterSpacing: 0.01,
                      decoration: TextDecoration.none,
                    )),
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
              height: height / 3,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: widget.imagePath,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Center(
                    child: Container(
                      width: width,
                      height: height / 3,
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
                imageBuilder: (context, imageProvider) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: InstaImageViewer(
                      child: Image(
                        image: imageProvider,
                        height: height / 3,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) => Skeleton(
                  width: width,
                  height: height / 3,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            uploadImagesContainer(width, height),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }



}