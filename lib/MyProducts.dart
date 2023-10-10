import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_hive_project/model/product_model.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {

  var box = Hive.box('myBox');
  List<ProductModel> productList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //api
    fetchProductsFromApi();
    //hive
    fetchProductsFromHive();
  }

  fetchProductsFromApi()async{
    var response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    var convertedJson = jsonDecode(response.body);
    var data = (convertedJson as List).map((e) => ProductModel.fromJson(e)).toList();
    box.put('AllProducts', data);
    print("data: ${data}");
    setState(() {});
  }

  fetchProductsFromHive(){
    var myData = box.get('AllProducts');
    productList = myData;
    print("mySavedData: $myData");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: productList == null?CircularProgressIndicator(): ListView.builder(
            itemCount: productList.length,
              itemBuilder: (context,index){
                return Container(
                  padding: EdgeInsets.all(8),
                  child:Text(productList[index].title!),
                );
              }
          ),
        )
    );
  }
}
