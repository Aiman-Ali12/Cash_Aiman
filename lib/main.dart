import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/auth/login.dart';
import 'data/providers/transactions_provider.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
void main() async{
  // await SentryFlutter.init(
  //       (options) {
  //       options.dsn = 'https://7e404d30d1a8c185a74fa439aef09b6d@o4510003721011200.ingest.us.sentry.io/4510003750371332';
  //       options.sendDefaultPii = true;
  //       options.tracesSampleRate = 0.01;
  //     },
  //     appRunner: () => runApp(const MyApp()),
  // );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // textError();
    return ChangeNotifierProvider(
      create: (_) => TransactionsProvider(),
      child: MaterialApp(
        title: 'دفتر النقدية',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  // Future<void> textError() async {
  //   try {
  //     int? num;
  //     int result =num! +1;
  //   }catch(exception ,stackTrace)  {
  //   await Sentry.captureException(
  //   exception ,
  //   stackTrace: stackTrace,
  //   );
  //   }
  // }
}