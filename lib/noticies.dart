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

Future<List<Noticia>?> fetchHTML(http.Client client, String newspaper) async {
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
  return refactorHTML(response, newspaper);
}

List<Noticia>? refactorHTML(Response response, String newspaper){
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
        var title = titleElement?.text;
        var imageElement = element.querySelector("div[class^='img-l-3col  ']")?.querySelector("img[src^='https']");
        var image = imageElement?.outerHtml.split(" ")[1].substring(5, imageElement.outerHtml.split(" ")[1].length - 1);

        Noticia n = Noticia(title: title ?? "", image: image ?? "", newspaper: newspaper);
        diariAndorraNew.add(n);

        /*print("---------------Title----------------");
        print(title_element?.text);
        print("---------------Image----------------");
        print(image_element?.outerHtml.split(" ")[1].substring(5, image_element.outerHtml.split(" ")[1].length - 1));*/
      }
      return diariAndorraNew;
    }
    break;
    case "BonDia":{
      //url = 'https://www.bondia.ad/';
      return null;
    }
    break;
    case "PeriodicAndorra":{
      //url = 'https://www.elperiodic.ad/';
      return null;
    }
    break;
    default:{
      //url = "";
      return null;
    }
    break;
  }
}

/*List<Noticia>? newsDiariAndorra(Noticia n)  {

  return null;
}*/