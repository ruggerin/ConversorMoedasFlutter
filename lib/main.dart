import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const urlRequest = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      primaryColorDark: Colors.amber

    )
  ));

}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar = 0;
  double euro = 0;
  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  void realChanged(String text){
    double real = double.parse(text) ;
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void dolarChanged(String text){
    double dolar = double.parse(text) ;
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar* this.dolar)/euro).toStringAsFixed(2);
  }
  void euroChanged(String text){
    double euro = double.parse(text) ;
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro* this.euro)/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de Moedas", textAlign: TextAlign.center,),
        backgroundColor: Colors.amber,

      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              // ignore: missing_return
              return Center(
                child: Text("Carregando Dados", style: TextStyle(color: Colors.amber, fontSize: 25),textAlign: TextAlign.center,),
              );
            default: if(snapshot.hasError){
              return Center(
                child: Text("Erro ao carregar a base de dados..."),
              );
            }else{
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                    Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                    buildTextField("Real", "R\$",realController, realChanged),
                    Divider(),
                    buildTextField("Dolar", "USD", dolarController, dolarChanged),
                    Divider(),
                    buildTextField("Euro", "€", euroController, euroChanged)
                  ],
                )
              );
            }

          }
        },
      ),
    );
  }
}


Future<Map> getData() async{
  http.Response response = await http.get(urlRequest);
  return jsonDecode(response.body);

}

buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
    controller: controller ,
    onChanged: f,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefix: Text( prefix , style: TextStyle(color:  Colors.amber),),
    ),
      style:  TextStyle(
        color: Colors.amber
    ),
  );
}
