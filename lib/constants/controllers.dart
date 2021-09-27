import 'package:untitled/controllers/appController.dart';
import 'package:untitled/controllers/authController.dart';
import 'package:untitled/controllers/product_controller.dart';
import 'package:untitled/controllers/cart_controller.dart';

// instance untuk controller sebagai dependency injection
AppController appController = AppController.instance;
UserController userController = UserController.instance;
ProductController productController = ProductController.instance;
CartController cartController = CartController.instance;
