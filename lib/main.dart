// @dart=2.9
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:octbs_ui/controller/translate.dart';
import 'package:octbs_ui/screens/users/Octoboss/select_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='pk_test_51L97rjA0fCP7bsOm4vGTFlIIogI0xngjJU1BquRXwDjEBsdqOrznbY576UiPcrDigpLpRbnPfR9FgEMEkacXxTcn005ZKRIPGy';

  await Hive.initFlutter();

  AwesomeNotifications().initialize(
      null, // icon for your app notification
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            soundSource: null,
            enableLights:true,
            importance: NotificationImportance.Max,
            enableVibration: true
        )
      ]
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Palette.kToDark
      ),
      translations: Translate(),
      debugShowCheckedModeBanner: false,
      home: SelectPage(),
    );
  }
}
class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xFF000000, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0x000000), //10%
      100: const Color(0xffb74c3a), //20%
      200: const Color(0xffa04332), //30%
      300: const Color(0xff89392b), //40%
      400: const Color(0xff733024), //50%
      500: const Color(0xff5c261d), //60%
      600: const Color(0xff451c16), //70%
      700: const Color(0xff2e130e), //80%
      800: const Color(0x000000), //90%
      900: const Color(0x000000), //100%
    },
  );
}