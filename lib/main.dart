import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget { //estrutura nao se modifica
  const MyApp({super.key});

  @override //reescrever uma classe q ja existe, como o build
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'TO-DO!',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(), //chama a pag principal
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( //traz a estrutura, body, appbar(nav)
      appBar: AppBar(title: const Text('Planejador de Tarefas')),
      body: Column(
        children: const [ //lista de qualquer coisa
        //Progress(),
        //Tasklist(),
        ],
      ),
    );
  }
}
