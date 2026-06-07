import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class fullNews extends StatefulWidget{

  String url;
  fullNews(this.url);

  @override
  fullNewsState createState()=>fullNewsState();
}

class fullNewsState extends State<fullNews>{
  late String finalUrl;
  // final Completer<WebViewController> controller=Completer();

  late final WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.url.toString().contains("http://")){
      finalUrl=widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalUrl=widget.url.toString();
    }

    controller=WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(finalUrl));

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("News"),centerTitle: true,),
      body:  WebViewWidget(controller: controller),
    );
  }
}