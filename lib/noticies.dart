import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Noticia {
  final String title;
  final String newspaper;
  final String link;
  final String image;

  const Noticia({
    required this.title,
    this.image = "",
    this.link = "",
    this.newspaper = ""
  });

}

Future<String> fetchHTML(http.Client client, String newspaper) async {
  var url = "";

  switch (newspaper){
    case "DiariAndorra":{
      url = 'https://www.diariandorra.ad/';
    }
    break;
    case "BonDia":{
      url = 'https://www.bondia.ad/';
    }
    break;
    case "PeriodicAndorra":{
      url = 'https://www.elperiodic.ad/';
    }
    break;
    default:{
      url = "";
    }
    break;
  }
  Response response = await client.get(Uri.parse(url),headers: {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  });
  refactorHTML(response, newspaper);
  return "";
}

void refactorHTML(Response response, String newspaper){
  var document = parse(response.body);
  switch (newspaper){
    case "DiariAndorra":{
      var titles = document.querySelectorAll("h2[id^='titulo-']");
      print(titles.length);
      titles.forEach((element) {print(element.text);});
    }
    break;
    case "BonDia":{
      //url = 'https://www.bondia.ad/';
    }
    break;
    case "PeriodicAndorra":{
      //url = 'https://www.elperiodic.ad/';
    }
    break;
    default:{
      //url = "";
    }
    break;
  }
}

List<Noticia>? newsDiariAndorra()  {

  return null;
}