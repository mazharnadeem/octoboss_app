// import 'package:flutter/material.dart';


// class TermsCondition extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: BlocBuilder<SettingsBloc, DataEvent>(
//           builder: (context, data){
//             if(data is ResponseData){
//               final response = data.data as String;

//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text('Terms And Condition', style:TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
//                     const SizedBox(height: 20,),
//                     Text(response, style:TextStyle( fontSize: 18),)
//                   ],
//                 ),
//               );
//             } else if(data is Initial || data is Loading){
//               return const Center(child: CircularProgressIndicator());
//             } else if (data is Error) {
//               return Center(child: Text('Erroe Found'));
//             } else if (data is Empty){
//               return const Center(child: Text('Empty'));
//             }
//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }
// }
