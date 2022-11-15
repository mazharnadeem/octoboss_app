// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

// class ServicesAPi extends StatefulWidget {
//   ServicesAPi({Key? key}) : super(key: key);

//   @override
//   State<ServicesAPi> createState() => _ServicesAPiState();
// }

// class _ServicesAPiState extends State<ServicesAPi> {
//   Future<ServicesResponse> getPostApi() async {
//     final response = await http
//         .get(Uri.parse("https://admin.noqta-market.com/new/API/Services.php"));
//     var data = jsonDecode(response.body.toString());
//     if (response.statusCode == 200) {
//       return ServicesResponse.fromJson(data);
//     } else {
//       return ServicesResponse.fromJson(data);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           'Fetch Services data',
//           style: TextStyle(color: Colors.orange),
//         ),
//         // Row(
//         //   children: [
//         //     // IconButton(
//         //     //     onPressed: () {},
//         //     //     icon: Icon(
//         //     //       Icons.arrow_back_ios,
//         //     //       color: Colors.orange,
//         //     //     )),
//         //     SizedBox(
//         //       width: 10,
//         //     ),
//         //     const Text(
//         //       'Fetch Services data',
//         //       style: TextStyle(color: Colors.orange),
//         //     ),
//         //   ],
//         // ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: FutureBuilder<ServicesResponse>(
//                   future: getPostApi(),
//                   builder: (context, snapshot) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.data!.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(
//                               left: 12, right: 12, top: 8),
//                           child: Card(
//                               child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       children: [
//                                         CircleAvatar(
//                                           backgroundImage: NetworkImage(snapshot
//                                               .data!.data![index].productImage
//                                               .toString()),
//                                           radius: 35,
//                                           backgroundColor: Colors.white,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Flexible(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(snapshot
//                                               .data!.data![index].productName
//                                               .toString()),
//                                           Text(snapshot
//                                               .data!.data![index].status
//                                               .toString()),
//                                           Text(snapshot
//                                               .data!.data![index].status
//                                               .toString()),
//                                           // Text(snapshot
//                                           //     .data!.data![index].languages
//                                           //     .toString()),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Column(
//                                     children: [
//                                       // GestureDetector(
//                                       //   onTap: () {},
//                                       //   child: Icon(
//                                       //     Icons.favorite,
//                                       //     color: Colors.red,
//                                       //   ),
//                                       // )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ],
//                           )),
//                         );
//                       },
//                     );
//                   }))
//         ],
//       ),
//     );
//   }
// }
