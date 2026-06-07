import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newspaper/category.dart';
import 'package:newspaper/data.dart';
import 'package:newspaper/fullnews.dart';

class news extends StatefulWidget{
  newsState createState()=>newsState();
}

class newsState extends State<news>{

  List<String> cat=["Sports","Politics","Artistic","Technology","Health","Weather"];
  TextEditingController search=TextEditingController();
  bool isLoading=true;

  List<NewsData> newsList=<NewsData>[];
  List<NewsData> newsProList=<NewsData>[];

  void getNewsByQuery(String query) async{
    String url="https://newsapi.org/v2/everything?q=$query&from=2026-04-31&sortBy=publishedAt&apiKey=apikey";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);
    Map element;
    int i=0;

    setState(() {
      for (element in data["articles"]){
        try {
          NewsData dataHolder = new NewsData();
          dataHolder = NewsData.fromMap(element);
          newsList.add(dataHolder);
          setState(() {
            isLoading = false;
          });
          i++;
          if (i == 10) break;
        }
        catch(e){
          print(e);
        }
      }
    });
  }

  void getNewsByProvider() async{
    String url="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=apikey";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);

    setState(() {
      data["articles"].forEach((element){
        try {
          NewsData dataHolder = new NewsData();
          dataHolder = NewsData.fromMap(element);
          newsProList.add(dataHolder);
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
    getNewsByQuery("India");
    getNewsByProvider();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("News"),centerTitle: true,),
      body: SingleChildScrollView(child:Container(child:Column(
        children: [
          Container(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(25)),
                margin:EdgeInsets.symmetric(horizontal: 10,vertical: 5),padding: EdgeInsets.all(5),child:Row(children: [
              InkWell(onTap: (){
                if((search.text).replaceAll(" ", "")==""){
                  print("no search");
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>category(Query: search.text)));
                }
              },child:Icon(Icons.search)),
              SizedBox(width: 10,),
              Expanded(child:
              TextField(textInputAction: TextInputAction.search,
                controller: search,
                onSubmitted: (value){
                if((value).replaceAll(" ", "")==""){
                  print("no search");
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>category(Query: value)));
                }},
                decoration: InputDecoration(
                hintText: "Seach any news",
                border: InputBorder.none
              ),))
            ],))
          ),
          Container(
            height: 60,
            child:ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
                itemCount: cat.length,
                itemBuilder: (context,index){
                  return InkWell(onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>category(Query: cat[index]))); },child:Container(
                    padding: EdgeInsets.symmetric(horizontal:10,vertical: 2),
                      margin: EdgeInsets.symmetric(horizontal:10,vertical:10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child:Center(child:Text(cat[index],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                  ));
                })
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
              child:!isLoading? CarouselSlider(
              items: newsProList.map((instance){
                return Builder(
                  builder: (BuildContext context){
                    try {
                      return Container(
                          child:InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>fullNews(instance.newsUrl)));
                            },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        instance.newsImg, fit: BoxFit.fitHeight,
                                        height: double.infinity,)
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(15),
                                              gradient: LinearGradient(colors: [
                                                Colors.black38,
                                                Colors.black54
                                              ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            child: Text(
                                                instance.newsHead, style:
                                            TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),)
                                      ))
                                ],
                              )
                          )));
                    }
                    catch(e){
                      print(e);
                      return Container();
                    }
                  },
                );
              }).toList(),options:
          CarouselOptions(
              height: 200,
              autoPlay: true,
            enlargeCenterPage: true
          ),): Container(height:200,child:Center(child:CircularProgressIndicator()))),
          Container(
            child:Column(children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                  child:Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("LATEST NEWS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)])),
              isLoading? Container(height: MediaQuery.of(context).size.height-450,child:Center(child:CircularProgressIndicator())):

              ListView.builder(
               physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: newsList.length,
                itemBuilder: (context,index){
                 try {
                   return
                   InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>fullNews(newsList[index].newsUrl)));
                     },
                       child:
                     Container(
                       height: 300,
                       margin: EdgeInsets.all(10),
                       child: Card(
                           elevation: 1.0,
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(15)
                           ),
                           child: Stack(
                             children: [
                               ClipRRect(
                                   borderRadius: BorderRadius.circular(15),
                                   child: Image.network(newsList[index].newsImg,
                                     fit: BoxFit.fitHeight,
                                     width: double.infinity,
                                     height: 300,)
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
            Container(
               padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>category(Query: "India")));}, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),child: Text("SHOW MORE",style: TextStyle(color:Colors.white),))
              ],
            ))])
          )

        ],
      ))),

    );
  }

  final List items=[Colors.black,Colors.yellow,Colors.pinkAccent];
}

// Image.asset("image/imagee.jpg")