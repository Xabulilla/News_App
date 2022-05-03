import 'dart:async';
import 'dart:convert';

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

Future<List<Noticia>> fetchHTML(http.Client client, String newspaper) async {
  var url = "";
  switch (newspaper){
    case "DiariAndorra":{
      url = 'https://www.diariandorra.ad';
    }
    break;
    case "BonDia":{
      url = 'https://www.bondia.ad';
    }
    break;
    case "PeriodicAndorra":{
      url = 'https://www.elperiodic.ad';
    }
    break;
    default:{
      url = "";
    }
    break;
  }

  List<Noticia> _news = refactorHTML(await http.get(Uri.parse(url),headers: { /*Deixar-ho així, NO crear una variable per response*/
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  }), newspaper, url);
  return _news;
}

List<Noticia> refactorHTML(Response response, String newspaper, String url){
  var document = parse(response.body);
  List<Noticia> diariAndorraNew = [];
  switch (newspaper){
    case "DiariAndorra":{
      /*var titles = document.querySelectorAll("h2[id^='titulo-']");
      print(titles.length);
      titles.forEach((element) {print(element.text);});*/

      //Mirar si dema el helisa-dnd-378 es el mateix, aixi agafem nomes les noticies mes importants
      var noticies = document.querySelectorAll("div[id^='Noticia-']");
      for (var element in noticies) {

        var titleElement = element.querySelector("h2[id^='titulo-']");
        var title = titleElement?.text.trim();
        print("---------------Title----------------");
        print(titleElement?.text);

        var linkElement = element.querySelector("h2[id^='titulo-']")?.querySelector("a[href^='/']");
        var link = linkElement?.outerHtml.split('"')[1];
        print("---------------Link----------------");
        print(link);
        if(link != null ) {
          link = url + link;
        } else {
          link = url;
        }
        print(link);

        var imageElement = element.querySelector("div[class^='img-l-3col  ']")?.querySelector("img[src^='https']");
        var image = imageElement?.outerHtml.split('"')[1];
        print("---------------Image----------------");
        print(imageElement?.outerHtml.split('"')[1]);


        Noticia n = Noticia(title: title ?? "", image: image ?? "", newspaper: newspaper, link: link );
        diariAndorraNew.add(n);


      }
      print("Notícies" + diariAndorraNew.length.toString());
      return diariAndorraNew;
    }
    break;
    case "BonDia":{
      //url = 'https://www.bondia.ad/';
      return List<Noticia>.empty();
    }
    break;
    case "PeriodicAndorra":{
      //url = 'https://www.elperiodic.ad/';
      return List<Noticia>.empty();
    }
    break;
    default:{
      //url = "";
      return List<Noticia>.empty();
    }
    break;
  }
}
