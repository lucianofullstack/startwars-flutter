import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc_mode/bloc/mode_bloc.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer();
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData(){
    BlocProvider.of<ModeBloc>(context).
      add(LoadDataEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 180,
              color: Colors.purple,
              child: 
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Image(
                        image: AssetImage('assets/logo.png'),
                        width: 120,
                        height: 120
                      ),
                      Text(
                        "STAR WARS",
                        style: 
                          TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                      )
                    ]
                  )
                )
            ),
            Expanded(
              flex: 8,
              child: Container(
                color:Colors.grey[50],
                child: ListView(
                  children: <Widget>[
                    _modeTile(),
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, 
              child: 
                Container(
                  color: Colors.purple,
                  child:
                    Center(
                      child: Text("© 2022 - Luciano Pereira",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _modeTile(){
    return BlocListener<ModeBloc, ModeState>(
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
            ListTile(
              leading: Icon(
                mode == true ? FontAwesomeIcons.globeAmericas : FontAwesomeIcons.powerOff, 
                size: 36, 
                color: mode == true ? Colors.purple : Colors.grey
              ),
              title: 
              Text(mode == true ? 'Modo Online' : 'Modo Offline',
                style: 
                  TextStyle(
                    fontSize: 18
                  )
              ),
              subtitle: 
                Text(
                  mode == true ? "Esperando Reporte" : "Sin Reporte"
                ),
              trailing: 
                Switch(
                  value: mode, 
                  onChanged: (stat) async {
                    BlocProvider.of<ModeBloc>(context).
                    add(SetDataEvent());
                    BlocProvider.of<ModeBloc>(context).
                    add(LoadDataEvent());
                  }
                )
          );
        }
      )
    );
  }
}