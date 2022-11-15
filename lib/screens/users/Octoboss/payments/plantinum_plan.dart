import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:pay/pay.dart';
class Plantinum extends StatefulWidget {
  const Plantinum({ Key? key }) : super(key: key);

  @override
  State<Plantinum> createState() => _PlantinumState();
}

class _PlantinumState extends State<Plantinum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            Divider(),
            _PLANTINUM(),
          ],
        ),
      ),
    );
  }
}
class _PLANTINUM extends StatelessWidget {
 
  final _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '12.99',
    status: PaymentItemStatus.final_price,
  )
];
 
  
  @override
  Widget build(BuildContext context) {

  
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Row(
            children: [
              ApplePayButton(
                paymentConfigurationAsset: 'applepay.json',
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              GooglePayButton(
                paymentConfigurationAsset: 'gpay.json',
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


