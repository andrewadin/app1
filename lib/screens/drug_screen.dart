import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:app1/models/Drug.dart';

class DrugScreen extends StatefulWidget {
  const DrugScreen({Key? key}) : super(key: key);
  State<DrugScreen> createState() => _DrugScreenState();
}

class _DrugScreenState extends State<DrugScreen>{
  // Creating new instance/object from Drug class as a List
  // The "?" mark indicates that the List will be fetched/filled in the future
  List<Drug>? drugs;
  // Creating variuable to see if the data has been fetched. 
  // False means data not fetched yet
  // True means data has been fetched
  var isLoaded = false;
  // Variable to save the API url, since the API is hosted locally
  // If using the android emulator the local API url start with "http://10.0.2.2"
  // If using the web app the local API url start with "http://127.0.0.1"
  String apiurl = '';

  // Getting data from the API when the screen is loaded/launched
  @override
  void initState() {
    super.initState();
    getData();
  }

  // Checking if the data has been fetched.
  // Using setState() to change the isLoaded variable if the data has been fetched
  getData() async {
    drugs = await getDrugs();

    if(drugs != null){
      setState(() {
        isLoaded = true;
      });
    }
  }

  // Calling the API
  Future<List<Drug>?> getDrugs() async {
    if(kIsWeb){
      apiurl = 'http://127.0.0.1:8000/api/drugs';
    }else{
      apiurl = 'http://10.0.2.2:8000/api/drugs';
    }
    // The API need auth header, so we need to use authorizationHeader from HttpHEaders class
    // The token can be accessed throughout the app because the LoginScreenState is public
    var response = await http.get(Uri.parse(apiurl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${LoginScreenState.token}',
    });

    // Converting the data from JSON to dart object when the API response code is 200 (success)
    if(response.statusCode == 200){
      var jsondata = response.body;
      return drugFromJson(jsondata);
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Drugs')),
      // Using Visibility because the element inside it will only be shown
      // if variable isLoaded value = true
      body: Visibility(
        visible: isLoaded,
        // replacement is visible on the screen if the object in "visible:" is false
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        // AlignGridView from flutter_staggered_grid_view library
        child: AlignedGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          itemCount: drugs?.length, 
          itemBuilder: (context, index){
            return Card(
              child: Column(
                children: [
                  Text(drugs![index].name,
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 15,),
                  RichText(text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Price\t:\t',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        )
                      ),
                       TextSpan(
                        text: drugs![index].price,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        )
                      )
                    ]
                  )
                  ),
                  const SizedBox(height: 5,),
                  RichText(text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Stocks\t:\t',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        )
                      ),
                       TextSpan(
                        text: drugs![index].stocks,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        )
                      )
                    ]
                  )
                  ),
                ],
              ),
            );
          }),
      ),
    );
  }
}