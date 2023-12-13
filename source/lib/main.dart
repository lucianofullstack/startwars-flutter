import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starwars/logics/load_logic.dart';
import 'package:starwars/repositories/mode_respository.dart';
import 'bloc_mode/bloc/mode_bloc.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'bloc_home/bloc/home_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ModeRepository repository = new ModeRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModeBloc(repository: repository),
      child: BlocProvider(
        create: (_) => HomeBloc(logic: SimpleLoadDataLogic()),
          child: 
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Star Wars',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              routes: {
                '/': (BuildContext context) => MyHomePage(title: 'Star Wars'),
                '/infopersonaje': (BuildContext context) => InfoPage(arguments: ModalRoute.of(context)!.settings.arguments as Map)
              }
            ),
      ),
    );
  }
}