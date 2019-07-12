import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


Map _data;
List _features;

void main() async{

_data = await getQuakes();
_features = _data['features'];


print(_data["features"][0]["properties"]);
  runApp(MaterialApp(

    title: "Quakes",
    home: new Quake(),


  ));

}

class Quake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

        title: new Text("Quakes"),
        centerTitle: true,
backgroundColor: Colors.red,


      ),

body: new Center(

  child: ListView.builder(
      itemCount: _features.length,
      padding: const EdgeInsets.all(15.0),

      itemBuilder: (BuildContext context, int position){
        //add rows for the List view


        if(position.isOdd) return new Divider();
        final index = position ~/ 2 ;
        var format = new DateFormat.yMMMMd("en_US").add_jm();
        var _date = format.format(DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000,
        isUtc: true
        ));





        return new ListTile(
          title:new Text("At: $_date ",

            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),


          ),

        subtitle: Text("${_features[index]['properties']['place'] }",

        style: new TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
          color: Colors.grey,

        ),

        ),


          leading: new CircleAvatar(
            backgroundColor: Colors.redAccent,

            child: Text("${_features[index]['properties']['mag'] }",


            style: new TextStyle(

              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.normal


            ),
            ),



          ),
onTap: () { _showAlertMessage(context,"${_features[index]["properties"]['title']}");

},
        );



      }


  ),

),





    );
  }






  void _showAlertMessage(BuildContext context, String message) {

var alert = new AlertDialog(

  title: Text("Quakes"),
  content: new Text(message),
actions: <Widget>[
  new FlatButton(onPressed:(){Navigator.pop(context);},
    child: new Text("Ok"),


  )


],



);
showDialog(context: context,child: alert);

  }}





Future<Map> getQuakes() async{
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";


  http.Response response = await http.get(apiUrl);



  return jsonDecode(response.body);

}

