import 'dart:convert';
import 'package:learn_flutter_3/model/herodata.dart';
import 'package:http/http.dart' as http;

class HeroApiConnection {
  String heroName;
  HeroData heroData;

  HeroApiConnection({this.heroName});

  Future<HeroData> getData() async {
    http.Response response = await http.get(
        'https://www.superheroapi.com/api.php/10224255825447393/search/$heroName');
    if (response.statusCode == 200) {
      try {
        Map json = jsonDecode(response.body);
        heroData = HeroData.fromJson(json);
      } catch (e) {}
      return heroData;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
