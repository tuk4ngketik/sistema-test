import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget{
  final idMeal;
  Detail(this.idMeal);
  DetailState createState()=> DetailState();
}

class DetailState extends State<Detail>{

  String idMeal;
  Map<String, dynamic> meals;
  List listMeals = [];
  List listIngredient = [];
  List listMeasure = [];
  bool loading = false;

  initState(){ 
    setState(() {
      idMeal = widget.idMeal;
    });
    _getDetail(idMeal);
    super.initState();
  }
  
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Container( 
        child:(meals == null) ? Center(child: CircularProgressIndicator() ,)  : ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[ 
            Center(
               child: Text(meals['strMeal'], style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),        

            Image.network(meals['strMealThumb'],fit: BoxFit.fitWidth,), 
            Text("Category: ${meals['strCategory']}",style:TextStyle( fontSize: 17),), 
            Text("Area: ${meals['strArea']}",style:TextStyle( fontSize: 17),), 
            Text("Tags: ${meals['strTags']}",style:TextStyle( fontSize: 17),), 

            Divider(),
            Row(
              children: <Widget>[
                Expanded(child: Text("Ingredient: ",style:TextStyle( fontSize: 17,fontWeight: FontWeight.bold),),flex: 5,),
                Expanded(child: Text("Measeure: ",style:TextStyle( fontSize: 17,fontWeight: FontWeight.bold),),flex: 5,), 
              ]
            ),
            Row(
              children: <Widget>[
                Expanded(
                   child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: listIngredient.map((v) => new Text("${v.toString()} :",style:TextStyle( fontSize: 16))).toList() //OK  
              ),
                flex: 5,
                ),
                Expanded(
                  child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: listMeasure.map((v) => new Text(v.toString(),style:TextStyle( fontSize: 16))).toList() //OK  
              ),
                flex: 5,
                ),
              ],
            ),
 
            Divider(),
            Text("Instructions: ",style:TextStyle( fontSize: 17,fontWeight: FontWeight.bold),),
            Text("${meals['strInstructions']}",style:TextStyle( fontSize: 17),),
            Divider(),
            FlatButton(
              onPressed:(){ 
                _launchURL("${meals['strYoutube']}");
              }, 
              child: Text("Youtube: ${meals['strYoutube']}",style:TextStyle( fontSize: 17),),
            ), 
            Divider(),
            FlatButton(
              onPressed:(){ 
                _launchURL("${meals['strSource']}");
              }, 
              child: Text("Source: ${meals['strSource']}",style:TextStyle( fontSize: 17),),
            ),              
            Divider(), 
            
          ],
        ),
      )
    );
  }

  _getDetail(String idMeal) async{
    setState(() {
      loading = true;
    });
    String url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal";
    var res = await http.get(url);
    if(res.statusCode == 200){      
      var data = jsonDecode(res.body); 
      setState(() {
        meals = data['meals'][0];
        meals.forEach((k, v) => listMeals.add(v));  
        loading = false; 
      });   
      List _listIngredient = [];
      List _listMeasure = [];
      for(var i=0 ; i < listMeals.length; i++){
          if( (i >= 9) & (i <= 28)){
            if(listMeals[i] != ""){ 
              _listIngredient.add(listMeals[i]);
            } 
          } 
          if((i>=29) & (i <= 48))
          { 
            if(listMeals[i] != ""){
              _listMeasure.add(listMeals[i]);
            } 
          }
      }   
      setState(() {
        listIngredient = _listIngredient;
        listMeasure = _listMeasure;
      });
    }
  }
 _launchURL(String u) async {
    const url = 'https://flutter.dev';
    if (await canLaunch(u)) {
      await launch(u);
    } else {
      throw 'Could not launch $url';
    }
  }
}