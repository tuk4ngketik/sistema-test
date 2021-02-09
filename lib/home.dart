import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home/list.dart';
import 'login.dart';

class Home extends StatefulWidget{ 
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{

  int _selectedIndex = 0;
  String url = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood'; 
  List meals;
  String email;

  initState(){
    _getList();
    _getSession();
    super.initState(); 
  }

  Widget build(BuildContext context){
    List<Widget> _widgetOption = <Widget>[ listMeal(context, meals),  _profil(email) ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[ 
          IconButton(icon:Icon(Icons.exit_to_app), onPressed: (){
            print('Exit');
            _sessionDestroy();
          }), 
        ],
      ), 
      body: Center(  
        child: ( (meals == null) || (email == null) ) ? CircularProgressIndicator() : _widgetOption.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),title:Text("Home") ),
          BottomNavigationBarItem(icon: Icon(Icons.person),title:Text("Profil") ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapItem, 
      ),
    );
  }

  _onTapItem(int index){
    setState(() {
      _selectedIndex = index;
      (index == 0) ? listMeal(context, meals) : _profil(email);
    });
  }
  

  Widget _profil(String email){
    return (email == null) ? Center(child: CircularProgressIndicator(),) : ListView(
      padding: EdgeInsets.only(top: 40,bottom: 10),
      children: <Widget>[
        Center(
          child:Text("Profil", style:TextStyle(fontWeight: FontWeight.bold,fontSize:30) ,),
        ),
        ListTile(
          leading: Icon(Icons.email), 
          title: Text("tai $email"),
        ),
        FlatButton(onPressed: (){
            Navigator.pushReplacement(context, 
              MaterialPageRoute(builder: (BuildContext ctx)=>Login())
            );
          },
         child: Text('Logout',style:TextStyle(fontWeight: FontWeight.bold,fontSize:17)),
        )
      ],
      //child: Text("Profil", style:TextStyle(fontWeight: FontWeight.bold),),
    );
  }

  Future _getList() async{
    var res = await http.get(url);
    if(res.statusCode == 200){
       var data = jsonDecode(res.body);
       setState(() {
        meals = data['meals']; 
       });   
    }
  }

  Future _getSession() async{ 
  SharedPreferences pref = await SharedPreferences.getInstance();
  String session = pref.getString('emailLogin') ;
    setState(() {
      email = session; 
    }); 
  }

  Future _sessionDestroy()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('emailLogin');
    Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (BuildContext ctx) => Login())
    );
  }

}