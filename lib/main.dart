import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:latest_0/prefs.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

var data = null;
var data_n = null;
bool notification = true;
String config = "";
List eventi = new List();
List eventi_I = new List();
List eventi_G = new List();
bool info = true;
int infoNews = 1;
int infoGuess = 1;

void main() {
  infoNews = 1;
  infoGuess = 1;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  read_().then((value) => config = value ).whenComplete(() => init().whenComplete(()
  {
    eventi_G = eventi;
    eventi_I = eventi;
    filter(config);
    if(config.contains("^")){
      String tempS = "";
      for(var s in config.split("^").sublist(1)){
        print("@"+s);
      }
    }
    runApp(MyApp());
  })
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latest_App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.black,
        splashColor: Colors.black12
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
} ////--------------------------------------
class _MyHomePageState extends State<MyHomePage> {

  Widget page = null;
  int selected = 1;
  List<String> titles = ["Notizie", "I miei interessi", "Scopri"];

  void getPage(int x, Size size){
    { setState(() {
      selected = x;
      switch(x){
        case 1: page = SingleChildScrollView( child:InterestPage());
        break;
        case 0: page = Stack(
            children: [
              NewsPage(),
              (infoNews == -1) ? Container() :
              Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Card(
                    elevation: 4,
                    child: SizedBox(
                      width: size.width * 0.85,
                      height: size.height * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.6,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only( top: size.height*0.025 ),
                                child: Text(
                                  "Nella sezione Notizie potrai tenerti aggiornato su tutte le notizie ufficiali riguardanti il mondo dei beni culturali",
                                  textAlign: TextAlign.center,
                                  style: TextStyle( fontWeight: FontWeight.w400, fontSize: 20 ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only( top: size.height*0.03 ),
                              child: RaisedButton(
                                elevation: 3,
                                disabledColor: Colors.black38,
                                color: Colors.grey,
                                onPressed: () => setState(() => infoNews = selected), ///
                                child: Text('OK', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w600 ) ),
                                shape: RoundedRectangleBorder(side: BorderSide( color: Colors.white70 ), borderRadius: BorderRadius.circular(5)),
                              )
                          )
                        ],
                      ),
                    ),
                  )
              )
            ]
        );
        break;
        case 2: page= Stack(children: [
          SingleChildScrollView( child:GuessPage()),
          (infoGuess == -1) ? Container() :
          Container(
              width: size.width,
              height: size.height,
              color: Colors.black54,
              alignment: Alignment.center,
              child: Card(
                elevation: 4,
                child: SizedBox(
                  width: size.width * 0.85,
                  height: size.height * 0.45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.6,
                            margin: EdgeInsets.only( top: size.height*0.01 ),
                            child: Text(
                              "Nella sezione Scopri troverai tutti gli eventi che non rispecchiano i tuoi interessi ma che potrebbero interessarti",
                              textAlign: TextAlign.center,
                              style: TextStyle( fontWeight: FontWeight.w400, fontSize: 20 ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only( top: size.height*0.03 ),
                          child: RaisedButton(
                            elevation: 3,
                            disabledColor: Colors.black38,
                            color: Colors.grey,
                            onPressed: (){ setState( () =>infoGuess = selected); },
                            child: Text('OK', style: TextStyle( color: Colors.white, fontWeight: FontWeight.w600 ) ),
                            shape: RoundedRectangleBorder(side: BorderSide( color: Colors.white70 ), borderRadius: BorderRadius.circular(5)),
                          )
                      )
                    ],
                  ),
                ),
              )
          )
        ]
        );
        break;
      }
    }); }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("---X"+selected.toString());
    if (infoNews!=-1 && infoNews!=1 ){ selected = infoNews; infoNews = -1;  setState(() {
      getPage(selected, size);
    }); }
    if (infoGuess!=-1 && infoGuess!=1){ selected = infoGuess; infoGuess = -1;  setState(() {
      getPage(selected, size);
    }); }
    print(".....A"+selected.toString());
    if (page == null) page = SingleChildScrollView(child:InterestPage());
    if (config.length == 0){ page = RegPage(); }
    else if(config == "?"){ page = CatsPage(); }
    else print(config);
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        //backgroundColor: Colors.red[800],
        resizeToAvoidBottomInset: false,
        appBar: (config.length != 0 && config != "?") ? AppBar(
          leading: Container(),
          backgroundColor: Colors.red[900],
          title: Text( titles[selected] ),
          centerTitle: true,
          elevation: 0,
          actions: config.length != 0 ? [ Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
                //icon: Icon( Icons.more_vert_rounded ), //Set Icon
                icon: Icon( Icons.settings_rounded ),
                onPressed: (){ setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                }); },
            ),
          ) ] : null,
        ) : null,
        bottomNavigationBar: config.length != 0 && config != "?" ? BottomNavigationBar(
          currentIndex: selected,
          selectedItemColor: Colors.red[900],
          unselectedItemColor: Colors.grey,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(icon: Icon( Icons.announcement ), label: "Notizie"),
            BottomNavigationBarItem(icon: Icon( Icons.assistant ), label: "I miei interessi"),
            BottomNavigationBarItem(icon: Icon( Icons.auto_stories ), label: "Scopri"),
          ],
          onTap: (x)=>getPage(x, size)
        ) : null,
        body: page,
      ),
    );
  }
} ////---------------------Completa

class InterestPage extends StatefulWidget {
  @override
  _InterestPageState createState() => _InterestPageState();
} ////------------------------------------
class _InterestPageState extends State<InterestPage> {
  String crits = '';
  List selections = ["Alfabetico\n(crescente)", "Alfabetico\n(decrescente)", "Data\n(crescente)", "Data\n(decrescente)"];
  String ord = "Alfabetico\n(crescente)";
  List temp = eventi_I;

  void sortEvents(String e){
    switch(e){
      case "Alfabetico\n(crescente)": return eventi_I.sort((a,b) => a.tit.compareTo(b.tit) );
      case "Alfabetico\n(decrescente)": return eventi_I.sort((a,b) => b.tit.compareTo(a.tit) );
      case "Data\n(crescente)": return eventi_I.sort((a,b) => a.seed.compareTo(b.seed) );
      case "Data\n(decrescente)": return eventi_I.sort((a,b) => b.seed.compareTo(a.seed) );
    }
  }

  Widget showItem(String o, bool d){
    Color c = (d) ? Colors.black87 : Colors.white;
    switch(o){
      case "Alfabetico\n(crescente)": return Icon( Icons.sort_by_alpha_rounded, textDirection: TextDirection.rtl, color: c);
      case "Alfabetico\n(decrescente)": return Transform.rotate(angle: -pi/1 ,child: Icon( Icons.sort_by_alpha_rounded, textDirection: TextDirection.ltr, color: c ));
      case "Data\n(crescente)": return Icon( Icons.update_outlined, textDirection: TextDirection.rtl, color: c );
      case "Data\n(decrescente)": return Transform.rotate(angle: -pi/1 ,child: Icon( Icons.update_outlined, textDirection: TextDirection.ltr, color: c ));
    }
  }

  bool inCats(String crits, List<String> gen){
    bool ts = false;
    for(String g in gen) if(g.contains(crits)) ts = true;
    return ts;
  }

  @override
  Widget build(BuildContext context) {
    if(crits != ''){
      temp = new List();
      crits = crits.toLowerCase().replaceAll(" ", "");
      for( Event e in eventi_I ) if (e.tit.toLowerCase().contains(crits) || e.regione.toLowerCase().replaceAll(" ", "").contains(crits) || inCats(crits, e.gen)) temp.add(e);
    }else temp = eventi_I;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
      Container(
      width: size.width,
      height: size.height*0.1,
          decoration: BoxDecoration(
              color: Colors.red[900],
              border: Border( bottom: BorderSide( color: Colors.black45 ) )
          ),
      child: Row(
        children: [
          Container(
            width: size.width*0.7,
            height: size.height*0.07,
            margin: EdgeInsets.symmetric( vertical: size.height*0.02, horizontal: size.width*0.03 ),
            decoration: BoxDecoration( borderRadius: BorderRadius.circular(45), color: Colors.black26, ),
            child: TextField(
              style: TextStyle( color: Colors.white ),
              onChanged: (String s){
                setState(() {
                  crits = s;
                });
              },
              showCursor: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white60,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
                    labelText: "Cerca evento, regione o genere...",
                    labelStyle: TextStyle( color: Colors.white60)
                ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
                icon: showItem(ord,false),
                items: [
                  DropdownMenuItem(child: showItem(selections[0],true), value: selections[0]),
                  //DropdownMenuItem(child: showItem(selections[1],true), value: selections[1]),
                  DropdownMenuItem(child: showItem(selections[2],true), value: selections[2]),
                  //DropdownMenuItem(child: showItem(selections[3],true), value: selections[3])
                ],
                onChanged: (value){
                  setState(() {
                    ord = value;
                    sortEvents(ord);
                  });
                }
            ),
          )
        ],
      ),
    ),
        SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height*0.74,
            child: eventi_I.length==0 ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Non ci sono eventi disponibili...\n",textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.w300, fontSize: 28 ),),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      config='';
                    });
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>MyHomePage()));},
                  child: getResetButton("Reset interessi", size.width * 0.45, size.height * 0.05),
                )
              ],
            ) :ListView(
                children: crits == '' ? eventi_I.map((e) => GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> Interest( e ))
                      );
                    },
                    child: getIntLine( e, size )
                )).toList()
                    :
                temp.map((e) => GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> Interest( e )));
                    },
                    child: getIntLine( e, size )
                )).toList()
            ),
          ),
        )
    ]
    );
  }
} ////-----------------Completa

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
} ////----------------------------------------
class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
      FutureBuilder( builder: (context, snapshot){
        return ListView.builder(
          itemCount: data_n.length,
          itemBuilder: (BuildContext context, int index){
            var d = data_n[index];
            String dd, mm_a;
            dd = d['data_pubblicazione'][0].toString().substring(8,10);
            mm_a = d['data_pubblicazione'][0].toString().substring(5,7) +'/'+ d['data_pubblicazione'][0].toString().substring(0,4);
            return GestureDetector(
                onTap: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> Scaffold(
                      floatingActionButton: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            onPressed: () => Share.share(
                                d['titolo'] +
                                    "\n\n" +
                                    d['data_pubblicazione'][1] +
                                    "\n" +
                                    "\n" +
                                    d['contenuto'] +
                                    "\n\n" +
                                    "Sei interessato ad altre notizie simili? Scarica subito My Exhibits su tutti gli store digitali!",
                                subject:
                                'Resta aggiornato sugli eventi d\'arte tramite My Exhibits, disponibile per tutte le piattaforme.'),
                            //elevation: 2.0,
                            fillColor: Colors.white.withOpacity(0.5),
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
                        title: Text("Notizie"),
                        centerTitle: true,
                        backgroundColor: Colors.red[900],
                        actions: <Widget>[
                          //IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
                        ],
                      ),
                      body: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Text(
                                    d['titolo'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.8)),
                                  ),
                                ),
                                Text(
                                  d['data_pubblicazione'][1],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black.withOpacity(0.7)),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 36,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                                  child: Text(
                                    d['contenuto'],
                                    //textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black.withOpacity(0.8)),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    )));
                  });
                },
                child: Card(
                  elevation: 1.5,
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.9,
                          padding: EdgeInsets.symmetric( horizontal: size.height * 0.02, vertical: size.width * 0.01 ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( (d['titolo'].toString().length>80) ? d['titolo'].toString().substring(0, 77).replaceAll("\n", " ")+"..." : d['titolo'].toString().replaceAll("\n", " "), maxLines: 3, style: TextStyle( fontWeight: FontWeight.bold ) ),
                              Padding(
                                padding: const EdgeInsets.only(top:5),
                                child: Text( dd + "/" + mm_a, style: TextStyle( fontWeight: FontWeight.w300 ) ),
                              )
                          ]
                        ),
                        )
                      ]
                  )
                  ),
                ),
            );
          },
        );
      },
        future: DefaultAssetBundle.of(context).loadString("assets/data/db_notizie.json"),
      );
  }
} ////-------------------------Completa

class GuessPage extends StatefulWidget {
  @override
  _GuessPageState createState() => _GuessPageState();
}
class _GuessPageState extends State<GuessPage> {
  String crits = '';
  List selections = ["Alfabetico\n(crescente)", "Alfabetico\n(decrescente)", "Data\n(crescente)", "Data\n(decrescente)"];
  String ord = "Alfabetico\n(crescente)";
  List temp = eventi_G;

  void sortEvents(String e){
    switch(e){
      case "Alfabetico\n(crescente)": return eventi_G.sort((a,b) => a.tit.compareTo(b.tit) );
      case "Alfabetico\n(decrescente)": return eventi_G.sort((a,b) => b.tit.compareTo(a.tit) );
      case "Data\n(crescente)": return eventi_G.sort((a,b) => a.seed.compareTo(b.seed) );
      case "Data\n(decrescente)": return eventi_G.sort((a,b) => b.seed.compareTo(a.seed) );
    }
  }

  Widget showItem(String o, bool d){
    Color c = (d) ? Colors.black87 : Colors.white;
    switch(o){
      case "Alfabetico\n(crescente)": return Icon( Icons.sort_by_alpha_rounded, textDirection: TextDirection.rtl, color: c);
      case "Alfabetico\n(decrescente)": return Transform.rotate(angle: -pi/1 ,child: Icon( Icons.sort_by_alpha_rounded, textDirection: TextDirection.ltr, color: c ));
      case "Data\n(crescente)": return Icon( Icons.update_outlined, textDirection: TextDirection.rtl, color: c );
      case "Data\n(decrescente)": return Transform.rotate(angle: -pi/1 ,child: Icon( Icons.update_outlined, textDirection: TextDirection.ltr, color: c ));
    }
  }

  bool inCats(String crits, List<String> gen){
    bool ts = false;
    for(String g in gen) if(g.contains(crits)) ts = true;
    return ts;
  }

  @override
  Widget build(BuildContext context) {
    if(crits != ''){
      temp = new List();
      crits = crits.toLowerCase().replaceAll(" ", "");
      for( Event e in eventi_G ) if (e.tit.toLowerCase().contains(crits) || e.regione.toLowerCase().replaceAll(" ", "").contains(crits) || inCats(crits, e.gen)) temp.add(e);
    }else temp = eventi_I;
    final size = MediaQuery.of(context).size;
    return Column(
        children: [
          Container(
            width: size.width,
            height: size.height*0.1,
            decoration: BoxDecoration(
                color: Colors.red[900],
                border: Border( bottom: BorderSide( color: Colors.black45 ) )
            ),
            child: Row(
              children: [
                Container(
                  width: size.width*0.7,
                  height: size.height*0.07,
                  margin: EdgeInsets.symmetric( vertical: size.height*0.02, horizontal: size.width*0.03 ),
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(45), color: Colors.black26, ),
                  child: TextField(
                    style: TextStyle( color: Colors.white ),
                    onChanged: (String s){
                      setState(() {
                        crits = s;
                      });
                    },
                    showCursor: false,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.white60,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45)),
                        labelText: "Cerca evento, regione o genere...",
                        labelStyle: TextStyle( color: Colors.white60)
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(child: DropdownButton(
                    icon: showItem(ord,false),
                    items: [
                      DropdownMenuItem(child: showItem(selections[0],true), value: selections[0]),
                      //DropdownMenuItem(child: showItem(selections[1],true), value: selections[1]),
                      DropdownMenuItem(child: showItem(selections[2],true), value: selections[2]),
                      //DropdownMenuItem(child: showItem(selections[3],true), value: selections[3])
                    ],
                    onChanged: (value){
                      setState(() {
                        ord = value;
                        sortEvents(ord);
                      });
                    }
                ))
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: size.width,
              height: size.height*0.74, //0.74 rivedi su Int
              child: eventi_G.length==0 ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Non ci sono eventi disponibili...\n",textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.w300, fontSize: 28 ),),
                  RaisedButton(
                        elevation: 4,
                        color: Colors.red[900],
                        textColor: Colors.white,
                        onPressed: (){
                          setState(() {
                            config='';
                          });
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>MyHomePage()));},
                        child: Text( "Reset interessi", style: TextStyle(  ), ),
                  )
                ],
              ) : ListView(
                  children: crits == '' ? eventi_G.map((e) => GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> Interest( e )));
                      },
                      child: getIntLine( e, size )
                  )).toList()
                      :
                  temp.map((e) => GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> Interest( e )));
                      },
                      child: getIntLine( e, size )
                  )).toList()
              ),
            ),
          )
        ]
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
} ////-------------------------------------
class _SettingPageState extends State<SettingPage> {
  String chNot = notification ? "Disattiva notifiche" : "Abilita notifiche";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text( "Impostazioni" ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: (){ setState(() {
              notification = !notification;
              chNot = notification ? "Disattiva notifiche" : "Abilita notifiche";
            }); },
            child: Container(
              width: size.width,
              height: size.height * 0.08,
              padding: EdgeInsets.all( size.height * 0.02 ),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.symmetric( horizontal: BorderSide( color: Colors.black, width: 0.2 ))
              ),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width * 0.7,
                    child: FittedBox(
                      child: Text( chNot, style: TextStyle( fontSize: 30 ), ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    alignment: Alignment.centerRight,
                    child: notification ? Icon( Icons.notifications_rounded ) : Icon( Icons.notifications_off_rounded ),
                  )
                ],
              ),
            ),
          ),
          Container(
              width: size.width,
              height: size.height * 0.08,
            padding: EdgeInsets.all( size.height * 0.02 ),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.symmetric( horizontal: BorderSide( color: Colors.black, width: 0.2 ))
              ),
            child: GestureDetector(
              onTap: (){ setState(() {
                config = "";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WillPopScope(
                                                          onWillPop: (){},
                                                          child: Scaffold(
                                                              body:RegPage(),
                    ),
                  )),
                );
              }); },
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width * 0.7,
                    child: FittedBox(
                      child: Text( "Reset interessi", style: TextStyle( fontSize: 30 ), ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: size.width * 0.2,
                    alignment: Alignment.centerRight,
                    child: Icon( Icons.wrap_text_sharp ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} ////-------------------Completa

