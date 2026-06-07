import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newspaper/data.dart';
import 'package:newspaper/fullnews.dart';

class category extends StatefulWidget{

  String Query;
  category({required this.Query});

  @override
  categoryState createState()=>categoryState();
}

class categoryState extends State<category>{


  bool isLoading=true;

  List<NewsData> newsList=<NewsData>[];


  void getNewsByQuery(String query) async{
    String url="https://newsapi.org/v2/everything?q=$query&from=2026-04-31&sortBy=publishedAt&apiKey=apikey";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);

    setState(() {
      data["articles"].forEach((element){
        try {
          NewsData dataHolder = new NewsData();
          dataHolder = NewsData.fromMap(element);
          newsList.add(dataHolder);
          setState(() {
            isLoading = false;
          });
        }
        catch(e){
          print(e);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("news"),centerTitle: true,),
      body: SingleChildScrollView(child:Container(
          child:Column(children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child:Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(widget.Query,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)])),
            isLoading?Container(child:Center(child:CircularProgressIndicator())):ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: newsList.length,
                itemBuilder: (context,index){
                  try {
                    return
                    InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>fullNews(newsList[index].newsUrl)));
                    },child:
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 300,
                        child: Card(
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                        newsList[index].newsImg,
                                        fit: BoxFit.fitHeight,
                                        width: double.infinity,
                                        height: 300)
                                ),
                                Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                          gradient: LinearGradient(colors: [
                                            Colors.black38,
                                            Colors.black54
                                          ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),

                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(newsList[index].newsHead,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(
                                                newsList[index].newsDes.length >
                                                    50
                                                    ? "${newsList[index]
                                                    .newsDes.substring(
                                                    0, 51)}..."
                                                    : newsList[index].newsDes,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),)
                                            ])
                                    )
                                )
                              ],
                            )
                        )
                    ));
                  }
                  catch(e){
                    print(e);
                    return Container();
                  }
                }),
            ])
      ))
    );
  }
}