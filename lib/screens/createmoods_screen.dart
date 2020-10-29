import 'package:flutter/material.dart';
import 'package:learn_flutter_3/model/herodata.dart';
import 'package:learn_flutter_3/services/heroapi_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateMoodsScreen extends StatefulWidget {
  static const String id = 'createmoods_screen';

  @override
  _CreateMoodsScreenState createState() => _CreateMoodsScreenState();
}

class _CreateMoodsScreenState extends State<CreateMoodsScreen> {
  String heroNameToSearch;
  var getHeroData;
  String namaHero;
  String imgHero;
  int selectedIndex = -1;
  String moodsText;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // getData();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      heroNameToSearch = value;
                      setState(
                        () {
                          getHeroData =
                              HeroApiConnection(heroName: heroNameToSearch)
                                  .getData();
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getHeroData,
                  builder: (context, AsyncSnapshot<HeroData> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        // shrinkWrap: true,
                        itemCount: snapshot.data.results.length,
                        itemBuilder: (BuildContext context, int index) {
                          var heroesData = snapshot.data.results[index];
                          return Column(
                            children: [
                              InkWell(
                                child: Card(
                                  shape: (selectedIndex == index)
                                      ? RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.blueAccent))
                                      : null,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                            child:
                                                Image.network(heroesData.img)),
                                        Flexible(
                                          child: Text(
                                            heroesData.name,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    height: 300.0,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                onTap: () {
                                  namaHero = heroesData.name;
                                  imgHero = heroesData.img;
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      return Text('Search your hero first');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Card(
          child: ListTile(
            leading: Text(
              'Moods',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            title: TextField(
              onChanged: (value) {
                moodsText = value;
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                /*print(namaHero);
                print(imgHero);
                print(moodsText);*/
                var loggedInUser = FirebaseAuth.instance.currentUser;
                await firestoreInstance
                    .collection('moods')
                    .doc(loggedInUser.email)
                    .set({
                      'namahero': '$namaHero',
                      'urlhero': '$imgHero',
                      'moodstext': '$moodsText'
                    })
                    .then((value) => print(
                        '${loggedInUser.displayName} berhasil menambahkan moods'))
                    .catchError(
                        (error) => print('Gagal menambahkan moods ke databse'));
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
