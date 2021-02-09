import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget{
  LoginState createState()=> LoginState();
}

class LoginState extends State<Login>{

  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailLogin = TextEditingController();

 Widget build(BuildContext context){
   return Scaffold( 
     body: Form(
       key: formKey,
        child:Container( 
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20), 
          child: Column(
          //padding: EdgeInsets.all(20),
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Text("Login", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Divider(),
                TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: TextEditingController(),
                    onSaved:(v) => emailLogin.text = v ,
                    validator: (v){
                      if(!v.contains('@')){
                        return 'Email tidak valid';
                      }return null;
                    },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(''),
                      flex: 5, 
                    ),
                    Expanded(
                      flex: 5, 
                      child:RaisedButton(
                        onPressed:(){
                            // save email
                           if(formKey.currentState.validate()){
                              setState(() {
                                loading = true;
                              });
                              formKey.currentState.save(); 
                              print(emailLogin.text);
                              _actionLogin();
                            }
                        },
                        child: Text("Login"),
                      ),
                    ),
                  ],
                ),
                (loading == false) ? Text('') : CircularProgressIndicator(),
            ],
          ), 
        )
      
     ),
   );
 }

 _actionLogin() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('emailLogin', emailLogin.text); 
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (BuildContext context) => Home())
          );
 }
}