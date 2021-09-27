import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/screens/home/widgets/products.dart';
import 'package:untitled/screens/home/widgets/shopping_cart.dart';
import 'package:untitled/widgets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: CustomText(
            text: "EjaX",
            size: 22,
            weight: FontWeight.bold,
            color: Colors.orange,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  showBarModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      color: Colors.white,
                      child: ShoppingCartWidget(),
                    ),
                  );
                })
          ],
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            children: [
              Obx(() => UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.black),
                  accountName: Text(
                    userController.userModel.value.name ?? "",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    userController.userModel.value.email ?? "",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))),
              ListTile(
                onTap: () {
                  userController.signOut();
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.orange,
                ),
                title: Text("Log out"),
              )
            ],
          ),
        ),
        body: Container(
          color: Colors.black,
          child: ProductsWidget(),
        ));
  }
}
