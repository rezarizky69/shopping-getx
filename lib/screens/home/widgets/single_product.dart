import 'package:flutter/material.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/models/product.dart';
import 'package:untitled/widgets/custom_text.dart';

class SingleProductWidget extends StatelessWidget {
  final ProductModel product;

  const SingleProductWidget({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 200,
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(.75),
                offset: Offset(3, 2),
                blurRadius: 12)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 150,
                )),
          ),
          CustomText(
            text: product.name,
            size: 16,
            weight: FontWeight.bold,
            style: FontStyle.italic,
          ),
          SizedBox(
            height: 5,
          ),
          CustomText(
            text: product.brand,
            color: Colors.grey,
            size: 12,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: CustomText(
                  text: "\$${product.price}",
                  size: 16,
                  weight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    size: 16,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    cartController.addProductToCart(product);
                  })
            ],
          ),
        ],
      ),
    );
  }
}
