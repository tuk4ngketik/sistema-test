import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'login.dart'; 
import 'home.dart'; 

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String session = pref.getString('emailLogin') ;

  runApp(
    MaterialApp(
      title: 'Test', 
      home: (session == null ) ? Login() : Home(), 
    )
  ); 
  
}// end main
