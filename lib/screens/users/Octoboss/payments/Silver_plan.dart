import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octbs_ui/controller/payment_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:pay/pay.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            Divider(),
            _CartTotal(),
          ],
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
 
  final _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '24.99',
    status: PaymentItemStatus.final_price,
  )
];
 
  
  @override
  Widget build(BuildContext context) {
    final paymentController=Get.put(PaymentController());

  
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              ElevatedButton(onPressed: () => paymentController.makePayment(amount: '5', currency: 'USD',id: 2), child: Text('Make Payment'))

            ],
          )
        ],
      ),
    );
  }
}