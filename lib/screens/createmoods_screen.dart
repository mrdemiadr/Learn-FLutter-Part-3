import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_flutter_3/model/hero.dart';

class CreateMoodsScreen extends StatefulWidget {
  static const String id = 'createmoods_screen';

  @override
  _CreateMoodsScreenState createState() => _CreateMoodsScreenState();
}

class _CreateMoodsScreenState extends State<CreateMoodsScreen> {
  Future<HeroData> getData() async {
    http.Response response = await http.get(
        'https://www.superheroapi.com/api.php/10224255825447393/search/batman');
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      HeroData heroData = HeroData.fromJson(json);
      return heroData;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: FutureBuilder(
              future: getData(),
              builder: (context, AsyncSnapshot<HeroData> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.results.length,
                    itemBuilder: (BuildContext context, int index) {
                      var heroesData = snapshot.data.results[index];
                      return Column(
                        children: [
                          InkWell(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.network(heroesData.img),
                                    Text(
                                      heroesData.name,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                height: 300.0,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            onTap: null,
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
        bottomSheet: Card(
          child: ListTile(
            leading: Text(
              'Moods',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            title: TextField(),
            trailing: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
