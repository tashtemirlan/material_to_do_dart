import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;

import '../login_screen_boarding.dart';



class ForgetPasswordPasswordReseted extends StatefulWidget{
  const ForgetPasswordPasswordReseted({super.key});

  @override
  ForgetPasswordPasswordResetedState createState ()=> ForgetPasswordPasswordResetedState();
}
class ForgetPasswordPasswordResetedState extends State<ForgetPasswordPasswordReseted>{

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
    double bottomNavBarHeight = kBottomNavigationBarHeight;
    double mainSizedBoxHeightUserNotLogged = height - bottomNavBarHeight - statusBarHeight;


    return PopScope(
      canPop: false,
      child: Scaffold(
          body:Padding(padding: EdgeInsets.only(top: statusBarHeight+ 10),
            child: Container(
              width: width,
              height: mainSizedBoxHeightUserNotLogged,
              color: const Color.fromRGBO(250, 250, 250, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width*0.75, height: height*0.3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/passwordReseted.png'),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: width*0.9,
                    height: 80,
                    child: Text(
                        AppLocalizations.of(context)!.password_successfully_reset, textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600
                        )),
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: width*0.9,
                    height: 40,
                    child: Text(
                        AppLocalizations.of(context)!.password_reset_description_string, textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300 , letterSpacing: 0.2
                        )),
                  ),
                  const SizedBox(height: 25,),
                  SizedBox(width: width*0.9, height: mainSizedBoxHeightUserNotLogged* 0.07,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => const LoginPage()));
                      },
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(colors.mainColor)
                      ),
                      child: Text(
                          AppLocalizations.of(context)!.login_text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white, letterSpacing: 0.2 , fontWeight: FontWeight.w500
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}