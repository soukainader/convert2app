import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              WebView(
                initialUrl: dotenv.env['URL'] ?? 'URL not found',
                javascriptMode: JavascriptMode.unrestricted,
              )
            ],
          ),
        ),
      ),
    );
  }
}
