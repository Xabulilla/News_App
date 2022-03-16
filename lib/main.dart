import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'noticies.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const MyHomePage(
        title: "Notícies d'Andorra",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _newspapers = <String>["Hola", "Que tal", "Hello", "World", "LOL"];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late Future<List<Noticia>?> _news;

  @override
  void initState() {
    super.initState();
    _news = fetchHTML(http.Client(), "DiariAndorra");
    //print(_data);
  }

  Widget _buildRow(Noticia newTitle) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text(
                newTitle.title,
                style: _biggerFont,
              ),
              subtitle: newTitle.image != "" ? Image.network(newTitle.image) : Text("No image"),
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
    Noticia _new = const Noticia(title: '');
    return FutureBuilder(
        future: _news,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, i) {
                  if (i <= snapshot.data.length) {
                    _new = snapshot.data[i];
                  }
                  return _buildRow(_new);
                });
          }
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
