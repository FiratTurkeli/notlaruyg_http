import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'Notlar.dart';

class NotDetaySayfa extends StatefulWidget {
  late Notlar not;


  NotDetaySayfa({required this.not});

  @override
  _NotDetaySayfaState createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {


  var tfdersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  Future<void> sil(String not_id)   async {
    var url = Uri.parse("http://kasimadalan.pe.hu/notlar/delete_not.php");
    var veri = {"not_id":not_id.toString()};
    var cevap = await http.post(url,body: veri);
    print("Not SİL cevap: ${cevap.body}");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));



  }

  Future<void> guncelle(String not_id, String ders_adi, int not1, int not2) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/notlar/update_not.php");
    var veri = {"not_id":not_id.toString()};
    var cevap = await http.post(url,body: veri);
    print("Not guncelle cevap: ${cevap.body}");

  }

  @override
  void initState() {

    super.initState();
    var not = widget.not;
    tfdersAdi.text = not.ders_adi.toString() ;
    tfNot1.text = not.not1.toString()  ;
    tfNot2.text = not.not2.toString()  ;


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Detay Sayfa"),
        actions: [
          TextButton(onPressed:(){
            sil(widget.not.not_id);
          }, child: const Text("Sil", style: TextStyle(color: Colors.white),)),
          TextButton(onPressed:(){
           guncelle(widget.not.not_id, tfdersAdi.text, int.parse(tfNot1.text), int.parse(tfNot2.text));

          }, child: const Text("Güncelle", style:  TextStyle(color: Colors.white),)),
        ],
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
    );
  }
}
