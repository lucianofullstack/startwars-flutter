import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bloc_mode/bloc/mode_bloc.dart';

class InfoPage extends StatefulWidget {
  final Map? arguments;
  const InfoPage({Key? key, this.arguments}) : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: Text(widget.arguments?["item"]["name"]),
      ),
      body: SafeArea(
        child: 
          Column(
            children: <Widget>[ 
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    children: [
                      _colorItem("Color de Cabello", widget.arguments?["item"]["hair_color"]),
                      _colorItem("Color de Piel", widget.arguments?["item"]["skin_color"]),
                      _colorItem("Color de Ojos", widget.arguments?["item"]["eye_color"]),
                      _planetaItem(widget.arguments?["item"]["homeworld"]),
                      _vehiculosItem(widget.arguments?["item"]["vehicles"])
                    ],
                    scrollDirection: Axis.vertical,
                  ),
                ),
              ),
              Container(
                height: 100, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget> [  
                    ReportButton(characterName: widget.arguments?["item"]["name"])
                  ]
                )
              )
            ],
          )
        )
    );
  }

  Widget _vehiculosItem(List vehiculos){
    Widget vehiculosWidget;
      if (vehiculos.length == 0){
        vehiculosWidget = Text(
          "No Tiene", 
          style: 
            TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 14
            ),
          textAlign: TextAlign.center,
        );
      }
      else{
        vehiculosWidget = 
        FutureBuilder<List>(
          future: loadData(vehiculos),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError){
            return Container(width:50);
          }
          else if (snapshot.connectionState == ConnectionState.waiting){
            return Padding(
              padding: const EdgeInsets.only(right:3.0),
              child: Container(width:80,child: LinearProgressIndicator()),
            );
          }
          else{
            List<Widget> listaVehiculos = [
              Text(
                "No Tiene", 
                style: 
                  TextStyle(
                    color: Colors.red, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16
                  ),
                textAlign: TextAlign.center,
              )
            ];
            if (snapshot.data != null && snapshot.data!.length > 0){
              listaVehiculos = [];
              for (var i = 0;i < snapshot.data!.length;i++){
                listaVehiculos.add(
                  Text(
                    snapshot.data?[i]["name"] ?? "-", 
                    style: 
                      TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: Colors.indigo
                      ),
                    textAlign: TextAlign.center,
                  )
                );
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: listaVehiculos
            );
          }
        });
    }
    
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 10),
      initiallyExpanded: true,
      title: Text("Vehículos"),
      children: <Widget>[
        vehiculosWidget,
        SizedBox(height:15)
      ],
    );
  }

  Widget _planetaItem(String planeta){
    Widget planetaWidget;
    if (planeta.trim().length == 0){
      planetaWidget = Text(
        "Desconocido", 
        style: 
          TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 14
          ),
        textAlign: TextAlign.center,
      );
    }
    else{
      planetaWidget = 
      FutureBuilder<List>(
      future: loadData([planeta]),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasError){
          return Container(width:50);
        }
        else if (snapshot.connectionState == ConnectionState.waiting){
          return Container(width:80,child: LinearProgressIndicator());
        }
        else{
          return Container(
              width: 100,
              decoration: BoxDecoration(
                color:Colors.black87,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                  child: 
                    Text(
                      snapshot.data?[0]["name"] ?? "-", 
                      style: 
                        TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 14
                        ),
                      textAlign: TextAlign.center,
                    )
              )
          );
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          "Planeta"
        ),
        trailing: 
          planetaWidget
      ),
    );
  }

  Widget _colorItem(String texto, String color){
    List<String> colores = [];
    if (color.contains(",")){
      colores = color.split(", ");
    }
    else{
      colores = [color];
    }

    colores.forEach((item){
      if (item == "auburn") colores[colores.indexOf(item)] = "#712f2c";
      else if (item == "white") colores[colores.indexOf(item)] = "#ffffff";
      else if (item == "brown") colores[colores.indexOf(item)] = "#964B00";
      else if (item == "blond") colores[colores.indexOf(item)] = "#faf0be";
      else if (item == "grey") colores[colores.indexOf(item)] = "#808080";
      else if (item == "blue") colores[colores.indexOf(item)] = "#0000FF";
      else if (item == "red") colores[colores.indexOf(item)] = "#FF0000";
      else if (item == "light") colores[colores.indexOf(item)] = "#FFE6E3";
      else colores[colores.indexOf(item)] = "Desconocido";
    });
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          texto
        ),
        trailing: 
          _colorBoxes(colores)
      ),
    );
  }

  Widget _colorBoxes(List<String> colores){
    List<Widget> colorBoxes = [];
    colores.forEach((item) {
      colorBoxes.add(
        Padding(
          padding: const EdgeInsets.only(right:3.0),
          child: item != "Desconocido" ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(int.parse(item.replaceAll("#","0xff"))),
                borderRadius: BorderRadius.circular(5.0),
                border: item == "#ffffff" ? Border.all() : null
              ),
          ) : 
          _desconocidoBox()
          ,
        )
      );
    });
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:colorBoxes
    );
  }

  Widget _desconocidoBox(){
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color:Colors.black87,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: 
          Text(
            "Desconocido", 
              style: 
                TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 14
                ),
                textAlign: TextAlign.center,
          )
      )
    );
  }

  Future<List> loadData(List items) async {
    List listaData = [];
    if (items.length > 0){
      for (var i = 0;i < items.length; i++){
        try {
          var response = await http.get(
            Uri.parse(items[i]),
            headers: {
              "Accept": "application/json"
            }
          );  
          Map? data = json.decode(response.body);
          listaData.add(data);
        } catch (e) {
          return [];          
        }
      }
    }
    return listaData;
  }
}

class ReportButton extends StatefulWidget {
  final String characterName;
  const ReportButton({Key? key, required this.characterName}) : super(key: key);
  @override
  _ReportButtonState createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  bool isSending = false;
  Future<void> sendReport() async{
    setState(() {
      isSending = true;    
    });

    DateTime now = DateTime.now();
    String convertedDateTime = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString()}-${now.minute.toString()}";
    http.post(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
      headers: {
        "Accept": "application/json"
      },
      body: jsonEncode(<String, String>{
        "userId": "1",
        "dateTime": convertedDateTime,
        "character_name" : widget.characterName
      }),
    ).then((response) {
      if (mounted) setState(() {
        isSending = false;
      });
      dialogReporte();
    }).catchError((onError) {
      Fluttertoast.showToast(
        msg: "ERROR! No se pudo enviar el Reporte",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      if (mounted) setState(() {
        isSending = false;
      });
    });  
  }
  
  @override
  Widget build(BuildContext context) {
    return 
    BlocListener<ModeBloc, ModeState>(
      listener: (context, state) {
        if (state is LoadedDataState == false){
          Container();  
        }
      },
      child: BlocBuilder<ModeBloc, ModeState>(
        builder: (context, state) {
          bool mode = false;
          if (state is LoadedDataState){
            mode = state.mode;
          }
          return 
          isSending == true ?
          Container(child:CircularProgressIndicator()) 
          :
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color:Colors.white),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text("Enviar Reporte", style: TextStyle(color: Colors.white, fontSize: 20),),
                )
              ] ,
            ),
            color: Colors.purple,//Color(0xff01DF74),
            onPressed: mode == true ? () async{
              sendReport();    
            } : null
          );
        }
      )
    );
  }

  void dialogReporte(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        contentPadding: EdgeInsets.only(top:20,bottom:5,left:20,right:20),
        content: 
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size:50
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: 
                    Text(
                      "Enviaste el Reporte correctamente!",
                      style: 
                        TextStyle(
                          color: Colors.deepPurple,
                          fontSize:22,
                          fontWeight: FontWeight.bold
                        ),
                      textAlign: TextAlign.center,
                    )
              ),
            ],
          ),
        ),          
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('LISTO'),
              textColor: Colors.teal,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      )
    );
  }
}