import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_to_do/ui_folder/start_folder/start_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
        MaterialApp(
          theme: ThemeData(
              colorScheme: ThemeData().colorScheme.copyWith(primary: const Color.fromRGBO(95, 51, 225, 1)),
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const[
            Locale('ru'),
            Locale('en')
          ],
          home: const SplashScreen(),
        )
    );
  });
}