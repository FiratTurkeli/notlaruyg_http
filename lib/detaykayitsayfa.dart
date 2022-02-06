import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;


class DetayKayitSayfa extends StatefulWidget {
  const DetayKayitSayfa({Key? key}) : super(key: key);

  @override
  _DetayKayitSayfaState createState() => _DetayKayitSayfaState();
}

class _DetayKayitSayfaState extends State<DetayKayitSayfa> {

  var tfdersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  Future<void> kayit(String ders_adi, int not1, int not2) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/notlar/insert_not.php");
    var veri = {"ders_adi":ders_adi,"not1":not1.toString(),"not2":not2.toString()};
    var cevap = await http.post(url,body: veri);
    print("Not ekle cevap: ${cevap.body}");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
    


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detay Kayıt Sayfa"),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0, left: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: "Derd adi"),
                  controller: tfdersAdi ,
                ),
                TextField(
                  decoration: const InputDecoration( hintText: "ders not1"),
                  controller: tfNot1,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: " ders not2"),
                  controller: tfNot2,
                ),

              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        kayit(tfdersAdi.text, int.parse(tfNot1.text), int.parse(tfNot2.text));


      },
          icon: const Icon(Icons.save),
          label: const Text("Kaydet"),

      ),
    );
  }
}
