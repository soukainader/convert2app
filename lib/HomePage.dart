import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  WebViewController? webViewController;
  late bool isLoading;
  late bool showErrorPage;
  ListQueue<int> _navigationQueue = ListQueue();
  int index = 0;
  int currentTab = 0;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    showErrorPage = false;
    isLoading = true;
  }

  void _splitScreen(int i) {
    setState(() {
      currentTab = i;
    });
    switch (i) {
      case 0:
        webViewController?.loadUrl(dotenv.env['URL1'] ?? 'URL not found');
        break;
      case 1:
        webViewController?.loadUrl(dotenv.env['URL2'] ?? 'URL not found');
        break;
      case 2:
        webViewController?.loadUrl(dotenv.env['URL3'] ?? 'URL not found');
        break;
      case 3:
        webViewController?.loadUrl(dotenv.env['URL4'] ?? 'URL not found');
        break;
      case 4:
        webViewController?.loadUrl(dotenv.env['URL5'] ?? 'URL not found');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String mycolor = dotenv.env['NAVCOLOR'] ?? 'Color not found';
    String valueString = mycolor.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color otherColor = Color(value);
    String mycolor1 = dotenv.env['ITEMCOLOR'] ?? 'Color not found';
    String valueString1 = mycolor1.split('(0x')[1].split(')')[0];
    int value1 = int.parse(valueString1, radix: 16);
    Color otherColor1 = Color(value1);
    int codePoint = int.parse(dotenv.env['ICON1'] ?? 'URL not found');
    int codePoint1 = int.parse(dotenv.env['ICON2'] ?? 'URL not found');
    int codePoint2 = int.parse(dotenv.env['ICON3'] ?? 'URL not found');
    int codePoint3 = int.parse(dotenv.env['ICON4'] ?? 'URL not found');
    int codePoint4 = int.parse(dotenv.env['ICON5'] ?? 'URL not found');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (_navigationQueue.isEmpty) return true;
            setState(() {
              isLoading = true;
              currentTab = _navigationQueue.last;
              _navigationQueue.removeLast();
            });
            _exitApp(context);
            return false;
          },
          child: Scaffold(
            body: Stack(
              children: [
                WebView(
                  initialUrl: dotenv.env['URL'] ?? 'URL not found',
                  zoomEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onProgress: (int progress) {
                    print("WebView is loading (progress : $progress%)");
                    //Supprimer le footer et fixer le header
                    webViewController
                        ?.runJavascript("javascript:(function() { " +
                            "var footer = document.getElementsByTagName('footer')[0];" +
                            "footer.parentNode.removeChild(footer);" +
                            "var nav = document.getElementsByClassName('navbar-toggle')[0];" +
                            "nav.parentNode.removeChild(nav);" +
                            "})()")
                        .then((value) =>
                            debugPrint('Page finished loading Javascript'))
                        .catchError((onError) => debugPrint('$onError'));
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      isLoading = false;
                    });
                  },
                  navigationDelegate: (NavigationRequest request) {
                    setState(() {
                      isLoading = true;
                    });
                    return NavigationDecision.navigate;
                  },
                  onWebResourceError: (error) {
                    setState(() {
                      isLoading = debugInstrumentationEnabled;
                      showErrorPage = true;
                    });
                  },
                  debuggingEnabled: true,
                  gestureNavigationEnabled: true,
                ),
                isLoading
                    ? Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                            child: Lottie.asset("assets/colour.json"),
                          ),
                        ),
                      )
                    : Container(),
                showErrorPage
                    ? Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  child: Lottie.asset("assets/lottie.json"),
                                ),
                                const Text(
                                  "vous êtes actuellement hors ligne",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Veuillez vérifier votre connexion Internet",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                RaisedButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 40),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                        showErrorPage = false;
                                      });
                                      webViewController!.reload();
                                    },
                                    color: Color(int.parse("0xff135888")),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: const Text(
                                      "Réessayez",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                const SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: otherColor,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: otherColor1,
              unselectedItemColor: const Color(0xffd8d8d8),
              currentIndex: currentTab,
              // handles onTap on bottom navigation bar item zcd
              onTap: (i) {
                _navigationQueue.addLast(currentTab);
                setState(() {
                  isLoading = true;
                });
                _splitScreen(i);
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(IconData(codePoint, fontFamily: 'MaterialIcons')),
                  label: dotenv.env['LABEL1'] ?? 'ICON1 not found',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconData(codePoint1, fontFamily: 'MaterialIcons')),
                  label: dotenv.env['LABEL2'] ?? 'ICON1 not found',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconData(codePoint2, fontFamily: 'MaterialIcons')),
                  label: dotenv.env['LABEL3'] ?? 'ICON1 not found',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconData(codePoint3, fontFamily: 'MaterialIcons')),
                  label: dotenv.env['LABEL4'] ?? 'ICON1 not found',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconData(codePoint4, fontFamily: 'MaterialIcons')),
                  label: dotenv.env['LABEL5'] ?? 'ICON1 not found',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    }
    if (await webViewController!.canGoForward()) {
      webViewController!.goForward();
      return false;
    }
    return true;
  }
}
