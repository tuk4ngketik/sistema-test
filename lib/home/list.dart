
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sistema_test/detail.dart';

Widget listMeal(BuildContext context, List meals){
  return Column(
    children: <Widget>[
      Container(
        child: Text("Meals", style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
      ),
      Expanded(
        child: ListView.builder(
            itemCount: (meals == null) ? 0 : meals.length,
            itemBuilder: (context, int index){
                return ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: Image.network(meals[index]['strMealThumb'], width: 80,),
                  title: Text(meals[index]['strMeal'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,)),
                  onTap: (){
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (BuildContext ctx) => Detail(meals[index]['idMeal']))
                    );
                  },
                );
            } 
        )
      
      )
    ],
  ); 
}
