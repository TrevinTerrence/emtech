import 'package:flutter/material.dart';
import 'package:helloworld/about.dart';
import 'package:helloworld/addrecipe.dart';
import 'package:helloworld/animasi.dart';
import 'package:helloworld/basket.dart';
import 'package:helloworld/history.dart';
import 'package:helloworld/home.dart';
import 'package:helloworld/itemBasket.dart';
import 'package:helloworld/login.dart';
import 'package:helloworld/newpopmoview.dart';
import 'package:helloworld/popularMovie.dart';
import 'package:helloworld/popularactor.dart';
import 'package:helloworld/quiz.dart';
import 'package:helloworld/search.dart';
import 'package:helloworld/studentList.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      print("login");
      runApp(MyLogin());
    } else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'about': (context) => const About(),
        'Basket': (context) => Basket(),
        'studentList': (context) => const StudentList(),
        'AddRecipe': (context) => const AddRecipe(),
        'Quiz': (context) => const Quiz(),
        'animasi': (context) => const Animasi()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), Search(), History()];
  final List<String> _title = ['Home', 'Search', 'History'];
  String _user_id = "";

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value;
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_title[_currentIndex]),
      ),
      drawer: myDrawer(),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.skip_previous),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.skip_next),
        ),
      ],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          fixedColor: Colors.teal,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Search",
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: "History",
              icon: Icon(Icons.history),
            ),
          ],
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(accountName: Text("xyz"), accountEmail: Text(_user_id), currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/150"))),
          ListTile(title: const Text("Inbox"), leading: const Icon(Icons.inbox), onTap: () {}),
          ListTile(
              title: const Text("My Basket "),
              leading: const Icon(Icons.shopping_basket),
              onTap: () {
                Navigator.pushNamed(context, "Basket");
              }),
          ListTile(
              title: const Text("Add Recipe "),
              leading: const Icon(Icons.add_circle),
              onTap: () {
                Navigator.pushNamed(context, "AddRecipe");
              }),
          ListTile(
              title: const Text("About"),
              leading: const Icon(Icons.help),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => const About()));
                Navigator.pushNamed(context, "about");
              }),
          ListTile(
              title: const Text("animasi"),
              leading: const Icon(Icons.animation),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => const About()));
                Navigator.pushNamed(context, "animasi");
              }),
          ListTile(
              title: const Text("Student List"),
              leading: const Icon(Icons.list),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => const About()));
                Navigator.pushNamed(context, "studentList");
              }),
          ListTile(
              title: const Text("Quiz"),
              leading: const Icon(Icons.quiz),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => const About()));
                Navigator.pushNamed(context, "Quiz");
              }),
          ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => const About()));
                doLogout();
              }),
          ListTile(
              title: const Text("Movie List"),
              leading: const Icon(Icons.movie_creation_outlined),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PopularMovie()));
              }),
          ListTile(
              title: const Text("Actor List"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PopularActor()));
              }),
          ListTile(
              title: const Text("new movie"),
              leading: const Icon(Icons.movie_edit),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewPopMovie()));
              }),
        ],
      ),
    );
  }
}
