

import 'package:firebase_example/models/notification_badge.dart';
import 'package:firebase_example/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
  ).then((value) => runApp(const MyApp()));
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(  
  padding: const EdgeInsets.all(8),
  children: <Widget>[
    Container(
      height: 50,
      color: Colors.amber[600],
      child: const Center(child: Text('Entry A')),
    ),
    Container(
      height: 50,
      color: Colors.amber[500],
      child: const Center(child: Text('Entry B')),
    ),
    Container(
      height: 50,
      color: Colors.amber[100],
      child: const Center(child: Text('Entry C')),
    ),
  ],
);

  }


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
      home:  ChangeNotifierProvider(
        create: (context) =>  FirestoreService(),
        child:   const FirebaseExample(title: 'My example')
      )  
    );
  }
}


class FirebaseExample extends StatefulWidget {
  const FirebaseExample({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<FirebaseExample> createState() => _FirebaseExampleState();
}

class _FirebaseExampleState extends State<FirebaseExample> {


  @override
  void initState()  {
    super.initState();   
   // _collectionCount = await _collectionRef.snapshots().length;
  }

 
  @override
  Widget build(BuildContext context) {

    var firebaseService = Provider.of<FirestoreService>(context);
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
        title: Text(widget.title),
      ),
      body:  
         Column(
          children:<Widget>[
             SizedBox(
              height: MediaQuery.of(context).size.height-115,
               child: StreamProvider<List<NotificationBadge>>(
                create:(context) => firebaseService.getNotificationBadgesStream(),
                initialData: const[],
                child:  const  NavigationExample()
                )
             )
          ]
        ),
     
    );
  }
}


class NotificationBadgeList extends StatelessWidget {
  const NotificationBadgeList({super.key});
  @override
  Widget build(BuildContext context) {
    var badges = Provider.of<List<NotificationBadge>>(context);

        return  ListView.builder(
                              itemBuilder: (context, index) {
                                var data = badges[index];
                                 return   Center(
                                  child:  NotificationBadgeItem( item: data)
                                 );
                              },
                              itemCount: badges.length
                              );
        
  }
}


class NotificationBadgeItem extends StatelessWidget {
   final NotificationBadge item;

   const NotificationBadgeItem({super.key, required this.item});

 @override
  Widget build(BuildContext context) {

    return   Column( mainAxisAlignment: MainAxisAlignment.center, verticalDirection: VerticalDirection.up, crossAxisAlignment: CrossAxisAlignment.center, children: [
      
      Container( margin: const EdgeInsets.only(top: 20), child:
      Row( mainAxisAlignment: MainAxisAlignment.center, children: [
       const Text("CITAS:    ",  textAlign: TextAlign.left,  style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold)),
        Badge(
               largeSize: 30,
               smallSize: 30,
              label: SizedBox(width:30, child: Text(item.citas.toString()  , textAlign: TextAlign.center ))
            ) 
        ])
      ),
      Container(  margin: const EdgeInsets.only(top: 20),
        child:
              Row(mainAxisAlignment: MainAxisAlignment.center,  children: [
                      const Text("CHAT:   ", textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       Badge( 
               largeSize: 30,
               smallSize: 30,
              label: SizedBox(width:30, child: Text(item.chat.toString()  , textAlign: TextAlign.center ))
            )
           
      ],)
      ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("GENERAL:   ", textAlign: TextAlign.left ,  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Badge(  
               largeSize: 30,
               smallSize: 30,
              label: SizedBox(width:30, child: Text(item.general.toString()  , textAlign: TextAlign.center ))
            ) 

        ])
      
    
    ]);


  }
  
}


class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var notifications =Provider.of<List<NotificationBadge>>(context);
    var chatBadge =notifications[0].chat.toString();
    var citasBadge = notifications[0].citas.toString();
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations:  <Widget>[
         const  NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge( label: Text(citasBadge), child: const Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon:  Badge(
              label: Text(chatBadge),
              child: const Icon(Icons.messenger_sharp),
            ),
            label: 'Chat',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'Home page',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex],
    );
  }
}
