import 'package:book_club/screens/root/root.dart';
import 'package:book_club/states/currentUser.dart';
import 'package:book_club/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Crates the instance of our current user
      // so the whole app has access to the current user
      create: (context) => CurrentUser(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: OurTheme().buildTheme(),
        home: OurRoot(),
      ),
    );
  }
}
