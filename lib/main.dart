import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notlar_uygulamasi_hhtp/detaykayitsayfa.dart';
import 'NotDetaySayfa.dart';
import 'Notlar.dart';
import 'NotlarCevap.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  List<Notlar> parseNotlarCevap(String cevap){
     return NotlarCevap.fromJson(json.decode(cevap)).notlarListesi;
  }

  Future<List<Notlar>> tumNotlarGoster() async {
    var url = Uri.parse("http://kasimadalan.pe.hu/notlar/tum_notlar.php");
    var cevap = await http.get(url);
    return parseNotlarCevap(cevap.body);
  }

  Future<bool> uygulamayiKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            uygulamayiKapat();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Notlar Uygulaması",style: TextStyle(color: Colors.white,fontSize: 16),),
            FutureBuilder<List<Notlar>>(
                future: tumNotlarGoster(),
                builder: (context,snapshot){
                  if(snapshot.hasData) {
                   var notlarListesi = snapshot.data;

                    double ortalama = 0.0;

                    if(!notlarListesi!.isEmpty){
                      double toplam = 0.0;

                      for(var n in notlarListesi){
                        toplam = toplam + (int.parse(n.not1)+int.parse(n.not2))/2;
                      }

                      ortalama = toplam / notlarListesi.length;
                    }

                    return Text("Ortalama : ${ortalama.toInt()}",style: const TextStyle(color: Colors.white,fontSize: 14),);
                  }else{
                    return const Text("Ortalama : 0",style: const TextStyle(color: Colors.white,fontSize: 14),);
                  }
                }
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Notlar>>(
          future: tumNotlarGoster(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var notlarListesi = snapshot.data;
              return ListView.builder(
                itemCount: notlarListesi!.length,
                itemBuilder: (context,indeks){
                  var not = notlarListesi[indeks];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not,)));
                    },
                    child: Card(
                      child: SizedBox(height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(not.ders_adi,style: const TextStyle(fontWeight: FontWeight.bold),),
                            Text(not.not1.toString()),
                            Text(not.not2.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DetayKayitSayfa()));
        },
        tooltip: 'Not Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
