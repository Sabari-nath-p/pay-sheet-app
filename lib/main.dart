import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paysheet_app/Screens/AuthenticationScreens/AuthenticationScreen.dart';
import 'package:paysheet_app/Screens/Owners/OwnerHomeScreen/OwnerHomeScreen.dart';
import 'package:paysheet_app/core/theme/app_theme.dart';
import 'package:paysheet_app/core/utils/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved language preference
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language_code') ?? 'en';
  final countryCode = prefs.getString('country_code') ?? 'US';

  runApp(PaysheetApp(locale: Locale(languageCode, countryCode)));
}

class PaysheetApp extends StatelessWidget {
  final Locale locale;

  const PaysheetApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Paysheet',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          locale: locale,
          fallbackLocale: const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
          translations: Languages(),
          home: AuthenticationScreen(),
        );
      },
    );
  }
}
