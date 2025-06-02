// import 'package:flutter/material.dart';
// import 'package:frontend/common/build_meal_card.dart';
// import 'package:go_router/go_router.dart';
// import 'analysis_page.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   DateTime selectedDate = DateTime.now();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFFB8E986),
//               onPrimary: Colors.black,
//               onSurface: Colors.black,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: Color(0xFF66BB6A),
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green[50],
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.green[700],
//           onPressed: () {
//             context.pop();
//           },
//         ),
//         title: Text(
//           '식단 기록',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             fontStyle: FontStyle.italic,
//             color: Colors.green[700],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: const Color(0xFFE6F1D8),
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedDate =
//                           selectedDate.subtract(const Duration(days: 1));
//                     });
//                   },
//                   child: const Icon(Icons.chevron_left),
//                 ),
//                 GestureDetector(
//                   onTap: () => _selectDate(context),
//                   child: Row(
//                     children: [
//                       Text(
//                         selectedDate.year == DateTime.now().year &&
//                                 selectedDate.month == DateTime.now().month &&
//                                 selectedDate.day == DateTime.now().day
//                             ? '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 (오늘)'
//                             : '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.green[700],
//                             fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(width: 8),
//                       Icon(Icons.calendar_today,
//                           size: 18, color: Colors.green[700]),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (selectedDate.isBefore(DateTime(DateTime.now().year,
//                         DateTime.now().month, DateTime.now().day))) {
//                       setState(() {
//                         selectedDate =
//                             selectedDate.add(const Duration(days: 1));
//                       });
//                     }
//                   },
//                   child: Icon(
//                     Icons.chevron_right,
//                     color: selectedDate.isBefore(DateTime(DateTime.now().year,
//                             DateTime.now().month, DateTime.now().day))
//                         ? Colors.black
//                         : Colors.grey[400],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 buildMealCard('아침', '샐러드', '오전 8:35', '220kcal',
//                     image: 'assets/salad.jpg'),
//                 const SizedBox(height: 16),
//                 buildMealCard('점심', '점심메뉴', '오후 12:10', '590kcal'),
//                 const SizedBox(height: 16),
//                 buildMealCard('저녁', null, null, null,
//                     placeholder: '오늘 저녁 식사를 기록하세요'),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFA4D18D),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//               ),
//               icon: const Icon(Icons.edit_note),
//               label: const Text('식단 추가하기',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white)),
//               onPressed: () {
//                 context.push('/add-meal');
//               },
//             ),
//           )
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.green[700],
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         currentIndex: 0,//홈일때
//         onTap: (index) {
//           if(index == 0) {
//             context.go('/home');
//           } else if (index == 1) {
//             context.go('/analysis');
//           } else if (index == 2) {
//             context.go('/refrigerator');
//           } else if (index == 3) {
//             context.go('/my');
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '분석'),
//           BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: '냉장고'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
//         ],
//       ),
//     );
//   }
// }
