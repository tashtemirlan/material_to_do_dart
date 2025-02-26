import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_to_do/global_folder/colors.dart' as colors;
import 'package:material_to_do/global_folder/endpoints.dart' as endpoints;

import '../../../data_class_folder/login_sign_up_folder/policy_data_class.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class PolicyScreen extends StatefulWidget{

  const PolicyScreen({super.key});

  @override
  PolicyScreenState createState ()=> PolicyScreenState();
}

class PolicyScreenState extends State<PolicyScreen> {

  bool dataGet = false;
  String mainText = "";

  //todo : => methods and voids :
  Future<void> getPolicy() async{
    final dio = Dio();
    dio.options.receiveTimeout = Duration(seconds: 30);
    dio.options.connectTimeout = Duration(seconds: 30);
    //set Dio response =>
    try{
      final response = await dio.get(endpoints.policyGetEndpoint);
      print(response);
      if(response.statusCode == 200){
        final result = policyDataClassFromJson(response.toString());
        if(result.data != null){mainText = result.data!;}
      }
    }
    catch(error){
      if(error is DioException){
        if (error.response != null) {
          String toParseData = error.response.toString();
          print(toParseData);
        }
      }
    }
  }

  Future<void> getData() async{
    await getPolicy();
    setState(() {
      dataGet = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return PopScope(
        canPop: false,
        child: Scaffold(
          body: Container(
              width: width,
              height: height,
              color: colors.scaffoldColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: statusBarHeight,),
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: FaIcon(FontAwesomeIcons.arrowLeft, color: colors.darkBlack, size: 24,),
                      ),
                      const SizedBox(height: 20,),
                      //тело
                      Text(
                        AppLocalizations.of(context)!.policy_string,
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 0.01, color: colors.darkBlack1
                        ),
                      ),
                      const SizedBox(height: 20,),
                      (dataGet)?
                      SizedBox(
                          width: width*0.95,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              mainText ,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14, color: colors.darkBlack1, fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                      ) :
                      SizedBox(
                        width: width,
                        height: height/2,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.mainColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,)
                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
}