import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:water_drink_reminder/core/constants.dart';
import 'package:water_drink_reminder/core/firebase_options.dart';
import 'package:water_drink_reminder/domain/entities/user.dart';
import 'package:water_drink_reminder/domain/firebase_notification.dart';
import 'package:water_drink_reminder/presentation/screens/home/home_page.dart';
import 'package:water_drink_reminder/presentation/screens/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fbn = FireBaseNotofication();
  await fbn.initNotifications();
  final init = await createInitialRoute(fbn);

  runApp(App(fireBaseNotofication: fbn, initialRoute: init));
}

Future<Map<String, String?>> createInitialRoute(
    FireBaseNotofication fBN) async {
  final notificationAppLaunch = await fBN.fetchInitialRoute();
  final user = (await Hive.openBox(userBox)).get(boxKey);
  Map<String, String?> initialRoute = {loginPageRoute: null};
  if (notificationAppLaunch.keys.last == homePageRoute || user != null) {
    initialRoute = {homePageRoute: notificationAppLaunch.values.last};
  }
  return initialRoute;
}

class App extends StatelessWidget {
  const App(
      {super.key,
      required FireBaseNotofication fireBaseNotofication,
      required Map<String, String?> initialRoute})
      : _fireBaseNotofication = fireBaseNotofication,
        _initialRoute = initialRoute;

  final FireBaseNotofication _fireBaseNotofication;
  final Map<String, String?> _initialRoute;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _fireBaseNotofication,
      child: AppView(initialRoute: _initialRoute),
      );
  }
}

class AppView extends StatelessWidget {
  const AppView({required initialRoute, super.key})
      : _initialRoute = initialRoute;

  final Map<String, String?> _initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: _initialRoute.keys.last,
      routes: {
        loginPageRoute: (_) => const LoginPage(),
        homePageRoute: (_) => HomePage(
              payload: _initialRoute.values.last ?? '',
            )
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
