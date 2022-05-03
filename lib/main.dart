import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(4, (index) {
          return Center(
            child: IconButton(
              icon: index == 0
                  ? Image.asset('assets/images/diari_andorra_logo.png')
                  : Icon(Icons.newspaper),
              iconSize: index == 0 ? 500 : 50,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiariAndorra()));
              },
            ),
          );
        }),
      ), //_buildNews(),
    );
  }
}

class DiariAndorra extends StatefulWidget {
  const DiariAndorra({
    Key? key,
  }) : super(key: key);
  @override
  State<DiariAndorra> createState() => _DiariAndorraState();
}

class _DiariAndorraState extends State<DiariAndorra> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  late Future<List<Noticia>> _news ;

  @override
  void initState()  {
    super.initState();
    _news = fetchHTML(http.Client(), "DiariAndorra");
  }

  _launchURLBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
              subtitle: newTitle.image != ""
                  ? Image.network(newTitle.image)
                  : const Text(""),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('SHOW MORE'),
                  onPressed: () {
                    _launchURLBrowser(newTitle.link);
                  }, //de moment no fa res el botó
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
    return Center(
      child: FutureBuilder(
          future: _news,
          builder: (BuildContext context, AsyncSnapshot<List<Noticia>> snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Done and no data'));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, i) {
                      if (i <= snapshot.data.toString().length) {
                        _new = snapshot.data![i];
                      }
                      return _buildRow(_new);
                    });
              }
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text('Error'); // error
            } else if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData){
              return CircularProgressIndicator(); // loading
            } else {
              return Text('Else');
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diari Andorra"),
      ),
      body: _buildNews(),
    );
  }
}
