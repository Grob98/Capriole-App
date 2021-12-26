import 'package:capriole_app/components/zone_button.dart';
import 'package:flutter/material.dart';

const Color secondaryColor = Color(0xff37474F);
const Color accentColor = Color(0xff1976D2);
const Color lightGrayColor = Color(0xffB0BEC5);
const Color cardGrayColor = Color(0xffF3F3F3);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capriole',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Capriole'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
            '${widget.title} SoundSystem',
            style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        foregroundColor: secondaryColor,
      ),
      drawer: _buildDrawer(),
      body: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(top: 10),
        height: double.infinity,
        child: _buildContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildContent() {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        const Text("Zonen", style: TextStyle(
          color: accentColor,
          fontSize: 24,
          fontWeight: FontWeight.bold
        )),
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: _buildControls(),
              ),
              Container(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: _buildGraphics(),
              ),
            ],
          )
        ),
        Container(
          height: 100,
          color: Colors.blue,
        )
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      //padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ZoneButton(zoneName: "Fly"),
          ZoneButton(zoneName: "Achtern"),
          ZoneButton(zoneName: "Salon"),
        ],
      )
    );
  }

  Widget _test() {
    return Container(
      color: Colors.red,
    );
  }

  Widget _buildGraphics() {
    return Container(
      child: const RotatedBox(
          quarterTurns: 1,
          child: Image(image: AssetImage('graphics/ship-top.png'))
      )
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text('SoundSystem'),
            selected: true,
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
