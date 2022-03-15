import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

void main() async {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          ),
          home: const MyHomePage(title: "Notícies d'Andorra",),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title }) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class Noticia {
  final String title;
  const Noticia({required this.title});
}
class _MyHomePageState extends State<MyHomePage> {
  final _newspapers = <String>["Hola", "Que tal", "Hello", "World", "LOL"];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late Future _data;
  Future<String> fetchHTML(http.Client client) async {

    Response response = await client.get(Uri.parse('https://www.diariandorra.ad/'),headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    final parsed = jsonEncode(response.body);
    var document = parse(response.body);
    //var ctd = document.querySelector('#ctd');
    var titles = document.querySelectorAll("h2[id^='titulo-']");
    print(titles.length);
    titles.forEach((element) {print(element.text);});
    return "";
    //return parseHTML(response.body.toString());
  }
  String parseHTML(String responseBody){
    final parsed = jsonEncode(responseBody);
    return parsed;
  }
  /*Future<http.Response?> fetchAlbum() async {
    var response = await http.Client().get(Uri.parse('https://www.diariandorra.ad/'),headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });

    if (response.statusCode == 200){
      var document = parse(response.body);
      var noticies = [];
      var l = [];
      //print(document.getElementById("antetitulo-192753").innerHtml.toString());
      document.getElementsByClassName("ali-l").forEach((element) {
        //noticies.add(element.children.first.innerHtml);
        noticies.add(element.children.);
        noticies.forEach((element) {
          var t = element.toString();
          print(t);
        });
        /*l.add(noticies[0].toString().split("/n"));
        if(l.length > 0){
        print(l.elementAt(l.length - 1));}*/
        //print(element.children.first.innerHtml);
      });
      //Iterator _divs = document.getElementsByClassName("padd-col c-w  w-100   ").iterator;
      //print(_divs.current.toString());

    } else {
      throw Exception();
    }
    return null;
  }*/
  @override
  void initState(){
    super.initState();
     _data = fetchHTML(http.Client());
     //print(_data);
  }
  Widget _buildRow(String newTitle) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text(newTitle, style: _biggerFont,),
              subtitle: Text('NewsPaper'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('SHOW MORE'),
                  onPressed: () {}, //de moment no fa res el botó
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('WEB SITE'),
                  onPressed: () {}, //de moment no fa res el botó
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNews() {
    String _new = "";
    return ListView.builder(
        itemCount: _newspapers.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder:  (context, i) {
          if(i <= _newspapers.length){
            _new = _newspapers[i];
          }
          return _buildRow(_new);
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildNews(),
    );
  }
}
