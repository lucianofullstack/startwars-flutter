import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'midrawer.dart';
import 'bloc_home/bloc/home_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override   
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: 
        MyDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
        mainAxisSize: MainAxisSize.max,
        children:<Widget>[ 
          Expanded(child: ListaPersonajes())
        ]
      ),
      ),
    );
  }
}

class ListaPersonajes extends StatefulWidget {
  const ListaPersonajes({Key? key}) : super(key: key);
  @override
  _ListaPersonajesState createState() => _ListaPersonajesState();
}

class _ListaPersonajesState extends State<ListaPersonajes> {
  @override
  void initState(){
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is ErrorLoadingDataState){
          _showError(state.message);
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is LoadingDataState){
            return Center(child: CircularProgressIndicator());
          }
          else if (state is ErrorLoadingDataState){
            _showError(state.message);
          }
          else if (state is LoadedDataState){
            return Column(
              children: <Widget>[ 
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: state.data.length,
                      itemBuilder: (context, index){
                        return _widgetItem(
                          state.data[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.blueGrey.withOpacity(0.15),
                          height: 1.0,
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          }
          else{
            return Center(child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  Icon(Icons.work, color: Colors.grey, size: 64),
                    Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Text(
                        "No hay personajes registrados",
                        style: 
                          TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    )
                ]
              )
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _showError(String message) { 
    return Center(
      child: 
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 64,
              color: Colors.red
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  10, vertical:15),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: 
                  TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: RawMaterialButton(
                onPressed: () {
                  _loadData();
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: 
                  Text(
                    "Reintentar",
                    style:
                      TextStyle(
                        fontSize: 18
                      )
                  ),
                  padding: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
              ),
            )
          ],
        ),
    );
  }

  void _loadData(){
    BlocProvider.of<HomeBloc>(context).
      add(LoadDataEvent());
  }

  Widget _widgetItem(dynamic item){
    String genero = "Desconocido";
    if (item["gender"] == "male"){
      genero = "Masculino";
    }
    else if (item["gender"] == "female"){
      genero = "Femenino";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:10.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          item["name"] ?? ""
        ),
        subtitle:
        Text("Altura: "+(item["height"]+"cm" ?? "-")+" | Peso: "+(item["mass"]+"kg" ?? "-")),
        trailing: 
          Container(
            width: 100,
            decoration: BoxDecoration(
              color:genero == "Masculino" ? Colors.deepPurple : genero == "Femenino" ? Colors.purple : Colors.black87,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
                child: 
                  Text(
                    genero, 
                    style: 
                      TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 14
                      ),
                    textAlign: TextAlign.center,
                  )
            )
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/infopersonaje', arguments: {"item": item});
          },
      ),
    );
  }
}