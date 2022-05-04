import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/dom.dart';
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

Future<List<Noticia>> fetchHTML(http.Client client) async {
  var url = "";
  late List<Noticia> _newsDiariAndorra;
  late List<Noticia> _newsBonDia;
  late List<Noticia> _news;


      url = 'https://www.diariandorra.ad';
      _newsDiariAndorra = refactorHTML(await http.get(Uri.parse(url),headers: { /*Deixar-ho així, NO crear una variable per response*/
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      }), "DiariAndorra", url);

      url = 'https://www.bondia.ad';
      _newsBonDia = refactorHTML(await http.get(Uri.parse(url),headers: { /*Deixar-ho així, NO crear una variable per response*/
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      }), "BonDia", url);

      url = 'https://www.elperiodic.ad';



  /*List<Noticia> _news = refactorHTML(await http.get(Uri.parse(url),headers: { /*Deixar-ho així, NO crear una variable per response*/
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*"
  }), newspaper, url);*/
  _news = _newsDiariAndorra + _newsBonDia;
  _news.shuffle();
  return _news;
}

List<Noticia> refactorHTML(Response response, String newspaper, String url){
  var document = parse(response.body);
  List<Noticia> diariAndorraNew = [];
  List<Noticia> bonDiaNew = [];
  switch (newspaper){
    case "DiariAndorra":{
      var importants = document.querySelectorAll("div[id^='helisa-dnd-378']");
      for (var noticia in importants){
        var noticies = noticia.querySelectorAll("div[id^='Noticia-']");
        for (var element in noticies) {

          var titleElement = element.querySelector("h2[id^='titulo-']");
          var title = titleElement?.text.trim();

          //print("---------------Title----------------");
          //print(titleElement?.text);

          var linkElement = element.querySelector("h2[id^='titulo-']")?.querySelector("a[href^='/']");
          var link = linkElement?.outerHtml.split('"')[1];
          //print("---------------Link----------------");
          //print(link);
          if(link != null ) {
            link = url + link;
          } else {
            link = url;
          }
          //print(link);

          var imageElement = element.querySelector("div[class^='img-l-3col  ']")?.querySelector("img[src^='https']");
          var image = imageElement?.outerHtml.split('"')[1];
          //print("---------------Image----------------");
          //print(imageElement?.outerHtml.split('"')[1]);


          Noticia n = Noticia(title: title ?? "", image: image ?? "", newspaper: newspaper, link: link );
          diariAndorraNew.add(n);


        }
      }


      print("Notícies" + " " + diariAndorraNew.length.toString());
      return diariAndorraNew;
    }
    break;
    case "BonDia":{

      //----------------Titular BonDia -------------------"
      AddTitular(document, url, newspaper, bonDiaNew);

      //----------------Altres noticies BonDia -------------------"
      var importants = document.querySelectorAll("div[class^='views-row views-row']");
      for (var i in importants){
        var articles = i.querySelectorAll("article[id^='node-921']");
        for (var a in articles){
          var titleElement = a.querySelector("h2[class^='title']");
          var title = titleElement?.text.trim();
          //print(title);
          
          var imageElement = a.querySelector("div[class^='field-image']")?.querySelector("img[src^='https']");
          var image = imageElement?.outerHtml.split('src=')[1].split('"')[1];
          //print(image);

          var linkElement = a.querySelector("h2[class^='title']")?.querySelector("a[href^='/']");
          var link = linkElement?.outerHtml.split('"')[1];
          if(link != null ) {
            link = url + link;
          } else {
            link = url;
          }
          //print(link);
          Noticia n = Noticia(title: title ?? "", image: image ?? "", newspaper: newspaper, link: link );
          bonDiaNew.add(n);
        }
      }
      print("Notícies" + " " + bonDiaNew.length.toString());
      return bonDiaNew;
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

void AddTitular(Document document, String url, String newspaper, List<Noticia> bonDiaNew) {
   var titular = document.querySelectorAll("div[class^='views-field views-field-title']").first;
  var title = titular.text.trim();
  var linkElement = titular.querySelector("a[href^='/']");
  var link = linkElement?.outerHtml.split('"')[1];

  //print(link);
  if(link != null ) {
    link = url + link;
  } else {
    link = url;
  }
  //print(link);
  Noticia n = Noticia(title: title ?? "", image: "", newspaper: newspaper, link: link );
  bonDiaNew.add(n);
}
