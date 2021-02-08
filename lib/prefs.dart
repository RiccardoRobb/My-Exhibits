import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latest_0/main.dart';
import 'dart:io';
import 'dart:async';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class Event {
  String tit, desc, ldt, img, info, map, regione, imap;
  List<String> gen, date;
  List<String> data;
  double seed;

  Event(String tt, String dd, String ld, String im, String ii,
      String ma, List<String> gg, List<String> dt, String r, String mm) {
    imap = mm;
    tit = tt;
    desc = dd;
    ldt = ld;
    img = im;
    info = ii;
    map = ma;
    for(int i=0; i<gg.length; i++) gg[i] = gg[i].replaceAll(" ", "");
    gen = gg;
    date = dt;
    regione = r;
    data = date[0].split("/");
    seed = int.parse(data[0]) + int.parse(data[1])*31 + double.parse(data[2])*365;
  }

}

class Interest extends StatefulWidget {
  Event event;

  Interest(Event e){ event = e; }

  @override
  _InterestState createState() => _InterestState(event);
}
class _InterestState extends State<Interest> {
  Event event;
  bool _selected = false;
  bool show = info;

  _InterestState(Event e){ this.event = e; }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [ Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RawMaterialButton(
                onPressed: () => setState((){
                  _selected = !_selected;
                  write_(config+"^"+event.seed.toString(), true);
                  read_().then((value) => print("->" + value) );
                }),
                //elevation: 2.0,
                fillColor: Colors.white.withOpacity(0.7),
                child: Icon(
                  Icons.favorite,
                  color: _selected ? Colors.red[800] : Colors.grey,
                  size: 30.0,
                ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
            ),
            RawMaterialButton(
              onPressed: () => Share.share(
                  event.tit+
                      "\n\n" +
                      event.ldt +
                      "\n" +
                      "\n" +
                      event.desc +
                      "\n\n" +
                      event.info +
                      "\n\n" +
                      "Sei interessato ad altri eventi d'arte? Scarica subito My Exhibits su tutti gli store digitali!",
                  subject:
                  'Resta aggiornato sugli eventi d\'arte tramite My Exhibits, disponibile per tutte le piattaforme.'),
              //elevation: 2.0,
              fillColor: Colors.white.withOpacity(0.7),
              child: Icon(
                Icons.share,
                color: Colors.red[800],
                size: 35.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.red[800],
          actions: <Widget>[
            //IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
          ],
        ),
        body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      //padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Image(
                                image: NetworkImage( event.img )
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                              child: Column(

                                children: [

                                  Text(
                                    event.tit,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.8)),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 36,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                                    child: Text(
                                      event.desc,
                                      //textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black.withOpacity(0.8)),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                                    child: Text("INFORMAZIONI",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.red[800].withOpacity(0.9),
                                          //backgroundColor: Colors.red[800].withOpacity(0.9)),
                                        )),
                                  ),
                                  Container(
                                      color: Colors.red[800].withOpacity(0.9),
                                      padding: EdgeInsets.only(top: 4.0, bottom: 0.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                                            child: Column(
                                              children: [
                                                Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Column(
                                                      children: [
                                                        ListTile(
                                                          leading: Icon(Icons.date_range),
                                                          title: const Text('Quando'),
                                                          subtitle: Text(
                                                              event.ldt.split(" ").sublist(2).join(" ").replaceFirst("-", "")
                                                          ),
                                                        ),]
                                                  ),
                                                ),
                                                Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Column(
                                                      children: [
                                                        ListTile(
                                                          leading: Icon(Icons.where_to_vote),
                                                          title: const Text('Dove'),
                                                          subtitle: Text(
                                                              event.info.split("\n")[0].split(":")[1].substring(1) + "\n" + event.info.split("\n")[1].split(":")[1].substring(1)
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                                Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Column(
                                                      children: [
                                                        ListTile(
                                                          leading: Icon(Icons.info),
                                                          title: const Text('Ulteriori informazioni'),
                                                          subtitle: Text(
                                                              event.info.split("\n").sublist(3, event.info.split("\n").length - 1).join("\n")
                                                          ),
                                                        ),
                                                      ]
                                                  ),
                                                ),

                                              ],
                                            )
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            /**/
                            InkWell(
                                child: Image(
                                    image: NetworkImage( event.imap )),
                                onTap: () => launch( event.map )),
                            //Padding(padding: const EdgeInsets.only(bottom: 16.0)),
                          ],
                        ),
                      )),
                ],
              ),
            )),
      ),
        (show) ? Container(
          width: size.width,
          height: size.height,
          color: Colors.black54,
          alignment: Alignment.center,
          child: Card(
            elevation: 4,
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.5,
                        alignment: Alignment.centerLeft,
                        //margin: EdgeInsets.symmetric( horizontal: size.width * 0.025, vertical: 12 ),
                        margin: EdgeInsets.fromLTRB( size.width*0.05, 12, 0, 12),
                        child: Text(
                          "Premi il cuore per ricevere notifiche quando ci sono aggiornamenti per questo evento",
                          textAlign: TextAlign.center,
                          style: TextStyle( fontWeight: FontWeight.w700 ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.3,
                        margin: EdgeInsets.fromLTRB( 0, 12, size.width*0.05, 12),
                        child: Container(
                          padding: EdgeInsets.all( size.width * 0.028 ),
                          decoration: BoxDecoration( shape: BoxShape.circle, color: Colors.black12 ),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red[800],
                            size: size.width * 0.08,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only( left: size.width*0.1 ),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1,
                          child: Container(
                            //color: Colors.green,
                            child: Checkbox(
                                value: !info,
                                activeColor: Colors.grey,
                                onChanged: (_value){
                                  setState(() => info = !info);
                                },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Non mostrare più",
                            style: TextStyle( color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12 ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only( /*left: size.width*0.1*/ ),
                    child: RaisedButton(
                      elevation: 3,
                      disabledColor: Colors.black38,
                      color: Colors.grey,
                      onPressed: (){ setState(() => show = false); }, ///
                      child: Text('OK', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w600 ) ),
                      shape: RoundedRectangleBorder(side: BorderSide( color: Colors.white70 ), borderRadius: BorderRadius.circular(5)),
                    )
                  )
                ],
              ),
            ),
          )
        ):Container()
    ]
    );
  }
}

Future<String> initConfig() async {
  return await rootBundle.loadString("assets/data/preferenze.txt");
}

Future init() async{
  var s = await rootBundle.loadString("assets/data/db_eventi.json");
  data = await json.decode( s );
  assert(data is List);
  for(var d in data){
    Event e = new Event(
          d['titolo'],
          d['descrizione'],
          d['luogo_e_data'],
          d['link_immagine'],
          d['informazioni'],
          d['mappa_on_click'],
          new List<String>.from(d['genere']),
          new List<String>.from(d['date']),
          d['regione'],
          d['mappa_img']);
    eventi.add(e);
  }
  eventi.sort((a,b) => a.tit.compareTo(b.tit) );
  var ss = await rootBundle.loadString("assets/data/db_notizie.json");
  data_n = await json.decode( ss );
  return data;
}

void filter(String x_){
  String s_ = '';
  read_().then((value) => s_=value ).whenComplete(() => print("-°"+s_));
  List<String> critss;
  if(x_.length > 0) critss = x_.substring(0,(x_.length-1)).split(".");
  else return;
  print("Fitro per: "+critss.toString());
  List<Event> temp = new List<Event>();
  List<Event> temp2 = new List<Event>();
  for(Event e in eventi) {
    bool th = false;
    bool tk = false;
    for (String h in critss) {
      if(e.gen.contains(h.replaceAll(" ", "").toLowerCase()) || h=='-') th =  true;
      if(e.regione==h || h=='£') tk = true;
    }
    if(th&&tk) temp.add(e);
    else temp2.add(e);
  }
  eventi_I = temp;
  eventi_G = temp2;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File("$path/preferenze.txt");
}

Future<File> write_(String s, bool a) async {
  final file = await _localFile;

  if(a) return await file.writeAsString('$s',mode: FileMode.append);
  return await file.writeAsString('$s');
}

Future<String> read_() async {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
}

Padding getCatButton( bool col, String text,double x, double y ){
  return Padding(
    padding: EdgeInsets.only(bottom: y/3),
    child: Container(
      alignment: Alignment.center,
      width: x,
      height: y,
      decoration: BoxDecoration(
        border: Border.all( color: !col ? Colors.black : Colors.red[700], width: !col ? 2 : 3 ),
        borderRadius: BorderRadius.all( Radius.circular(45) )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric( vertical: 3, horizontal: 1 ),
        child: Text( text, textAlign: TextAlign.center, style: TextStyle( color: !col ? Colors.black : Colors.red[800], fontWeight: !col ? FontWeight.normal : FontWeight.bold ), ),
      )
    ),
  );
}


Padding getResetButton( String text,double x, double y ){
  return Padding(
    padding: EdgeInsets.only(bottom: y/3),
    child: Container(
        alignment: Alignment.center,
        width: x,
        height: y,
        decoration: BoxDecoration(
            border: Border.all( color: Colors.red[800], width: 3 ),
            borderRadius: BorderRadius.all( Radius.circular(45) ),
            color: Colors.red[700]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric( vertical: 3, horizontal: 1 ),
          child: Text( text, textAlign: TextAlign.center, style: TextStyle( color: Colors.white, fontWeight: FontWeight.normal ), ),
        )
    ),
  );
}

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {

  List<String> regsN = ["Lombardia","Lazio","Campania","Sicilia","Veneto","Emilia-Romagna","Piemonte","Puglia","Toscana",
                        "Calabria","Sardegna","Liguria","Marche","Abruzzo","Friuli-Venezia Giulia","Trentino-Alto Adige",
                        "Umbria","Basilicata","Molise","Valle d'Aosta"];
  List<bool> regs = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];

  List<Widget> getRegRows(Size size){
    List<Widget> temp = new List<Widget>();
    info = true;
    for(int index=0; index<20; index+=2) {
        temp.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              elevation: 2,
              color: (regs[index]) ? Colors.black12 : Colors.white,
              textColor: (regs[index]) ? Colors.white : Colors.black,
              onPressed: () => setState(() {
                regs[index] = !regs[index];
              }) , ///
              child: SizedBox( width: size.width * 0.3, child: Text(regsN[index], style: TextStyle( fontWeight: FontWeight.w600 ), textAlign: TextAlign.center, )),
              shape: RoundedRectangleBorder(side: BorderSide( color: (regs[index]) ? Colors.black12 : Colors.white ), borderRadius: BorderRadius.circular(5)),
            ),
            RaisedButton(
              elevation: 2,
              color: (regs[index+1]) ? Colors.black12 : Colors.white,
              textColor: (regs[index+1]) ? Colors.white : Colors.black,
              onPressed: () => setState(() {
                regs[index+1] = !regs[index+1];
              }) ,
              child: SizedBox( width: size.width * 0.3, child: Text(regsN[index+1], style: TextStyle( fontWeight: FontWeight.w600 ), textAlign: TextAlign.center, )),
              shape: RoundedRectangleBorder(side: BorderSide( color: (regs[index+1]) ? Colors.black12 : Colors.white ), borderRadius: BorderRadius.circular(5)),
            )
          ],
        ));
      };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.fromLTRB( size.width * 0.09, size.height * 0.03, size.width * 0.09, 0 ),
            child: Text("Ciao, vogliamo conoscerti meglio. Seleziona le regioni di cui vuoi visualizzare gli eventi culturali", textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.w300, fontSize: 28 ),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 7, 0, 10),
            child: Text("(puoi non esprimere preferenze)", style: TextStyle( fontSize: 15 ),),
          ),
          for(Widget e in getRegRows(size)) e,
          Padding(
            padding: EdgeInsets.fromLTRB( 0, 8, 0, 12 ),
            child: RaisedButton(
                color: Colors.red[800],
                textColor: Colors.white,
                elevation: 3,
                child: SizedBox( width: size.width * 0.25, child: Text("Avanti", style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold ), textAlign: TextAlign.center, )),
                shape: RoundedRectangleBorder(side: BorderSide( color: Colors.red[800] ), borderRadius: BorderRadius.circular(5)),
                onPressed: (){
                  config = "?";
                  String outR = '';
                  if(regs.any((element) => element)) {
                    for (int i = 0; i < regs.length; i++)
                      if (regs[i]) outR += regsN[i] + '.';
                  }else outR += "£.";
                  write_(outR, false);
                  read_().then((value) => print("->" + value) );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}


class CatsPage extends StatefulWidget {
  @override
  _CatsPageState createState() => _CatsPageState();
}
class _CatsPageState extends State<CatsPage> {
  List<bool> scelte = [ false, false, false, false, false, false, false ];
  List<String> scelteN = ["Arte contemporanea", "Personale","Fotografia","Collettiva","Arte moderna","Serata – evento","Arte antica" ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.fromLTRB( size.width * 0.09, size.height * 0.03, size.width * 0.09, 0 ),
          child: Text("Seleziona le categorie di tuo interesse", textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.w300, fontSize: 28 ),),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 7, 0, size.height * 0.06),
          child: Text("(puoi non esprimere preferenze)", style: TextStyle( fontSize: 15 ),),
        ),
        for(int s=0; s<scelte.length; s++)
          RaisedButton(
            elevation: 2,
            color: (scelte[s]) ? Colors.black12 : Colors.white,
            textColor: (scelte[s]) ? Colors.white : Colors.black,
            onPressed: () => setState(() { scelte[s] = !scelte[s]; }), ///
            child: SizedBox( width: size.width * 0.45, child: Text(scelteN[s], style: TextStyle( fontWeight: FontWeight.w600 ), textAlign: TextAlign.center, )),
            shape: RoundedRectangleBorder(side: BorderSide( color: Colors.white70 ), borderRadius: BorderRadius.circular(5)),
          ),
          Padding(
            padding: EdgeInsets.only( top: size.height * 0.06 ),
            child: RaisedButton(
                color: Colors.red[800],
                textColor: Colors.white,
                elevation: 3,
                child: SizedBox( width: size.width * 0.25, child: Text("Avanti", style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold ), textAlign: TextAlign.center, )),
                shape: RoundedRectangleBorder(side: BorderSide( color: Colors.red[800] ), borderRadius: BorderRadius.circular(5)),
                onPressed: ()=> (scelte.contains(true)) ? setState(() {
                  eventi = new List<Event>();
                  init().whenComplete(() {String temp = '';
                  if( scelte.contains(true) ){
                    for(int i=0; i<scelte.length; i++) if(scelte[i]) temp += scelteN[i] + '.';
                    config = temp;
                    write_(config, true);
                    read_().then((value) => config = value ).whenComplete((){ filter(config);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );});
                  }} );
                }) : setState(() {
                  eventi = new List<Event>();
                  init().whenComplete(()
                  {config += '-';
                  write_("-.",true);
                  read_().then((value) => config = value ).whenComplete((){
                    filter(config);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  });});
                })
            ),
          )
      ],
    );
  }
}

Widget getIntLine( Event e, Size size ){
  return Card(
    elevation: 2,
    child: Row(
      children: [
        Container(                  // IMG
          width: size.width * 0.2,
          height: size.height * 0.09,
          margin: EdgeInsets.only( left: size.width * 0.02 ),
          decoration: BoxDecoration(
              border: Border.symmetric( vertical: BorderSide( color: Colors.black45, width: 0.5 ), horizontal: BorderSide( color: Colors.black45, width: 0.5 ) )
          ),
          child: Image( image: NetworkImage( e.img ), fit: BoxFit.cover, ),
        ),

        Container(                  // TITOLO e DATA
          width: size.width * 0.7,
          height: size.height * 0.1,
          padding: EdgeInsets.symmetric( horizontal: size.height * 0.02, vertical: size.width * 0.01 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text( (e.tit.length <= 47) ? e.tit : e.tit.substring(0, 47) + "...", style: TextStyle( fontWeight: FontWeight.bold ), textAlign: TextAlign.left, ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text( e.data[0] +'/'+ e.data[1] +'/'+ e.data[2], style: TextStyle( fontWeight: FontWeight.w300 )  ),
              ),
            ],
          )
        ),
      ]
    )
  );
}

