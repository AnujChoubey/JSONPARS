import 'dart:convert';

import 'package:JSONPARS/photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MainFetchData());

class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<MainFetchData> {
  List<Photo> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("https://jsonplaceholder.typicode.com/photos");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  // _makePostRequest() async {
  //   // set up POST request arguments
  //   String url = 'https://jsonplaceholder.typicode.com/posts';
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  //   // make POST request
  //   final response = await http.post(url, headers: headers, body: json);
  //   // check the status code for the result
  //   int statusCode = response.statusCode;
  //   // this API passes back the id of the new item added to the body
  //   String body = response.body;
  //   {
  //   title: "Hello";
  //   body: "body text";
  //   userId: 1;
  //   id: 101;
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fetch Data JSON"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // _makePostRequest();
              },
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text("Fetch Data"),
            onPressed: _fetchData,
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text(list[index].title),
                    trailing: Image.network(
                      list[index].thumbnailUrl,
                      fit: BoxFit.cover,
                      height: 40.0,
                      width: 40.0,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
