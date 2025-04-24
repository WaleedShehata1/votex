// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import '../../controller/home/home_controller.dart';
// import '../../core/constants/images.dart';
// import '../../core/widget/custom_text_field.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   bool isEnabl = true;
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeControllerImp>(
//       builder: (controller) {
//         return SafeArea(
//           child: Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: CustomTextField(
//                 // controller: controller.search,
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () => controller.getSearch(controller.search.text),
//                     child: Image.asset(
//                       Images.iconSearch,
//                       width: 10.w,
//                       fit: BoxFit.fill,
//                       color: const Color(0xff7f7f7f),
//                     ),
//                   ),
//                 ),
//                 width: 260.w,
//                 height: 40.h,
//                 isEnabled: isEnabl,
//                 colorFill: Theme.of(context).colorScheme.secondaryContainer,
//                 colorBorder: Theme.of(context).colorScheme.secondaryContainer,
//                 hintText: "search".tr,
//                 borderRadius: 17.r,
//                 onChanged: (val) async {
//                   setState(() {});
//                   print(val);
//                   await Future.delayed(const Duration(milliseconds: 600), () {
//                     if (val != '') {
//                       isEnabl = false;
//                       return controller.getSearch(val);
//                     }
//                     isEnabl = true;
//                   });
//                 },
//               ),
//             ),
//             body:
//                 controller.isLoadingSearch.value
//                     ? Center(child: CircularProgressIndicator())
//                     : controller.itemListSearch.isEmpty
//                     ? Center(
//                       child: Text(
//                         'No Item Found',
//                         style: TextStyle(color: Theme.of(context).hintColor),
//                       ),
//                     )
//                     : Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: ListView.builder(
//                         itemCount: controller.itemListSearch.length,
//                         itemBuilder: (ctx, index) {
//                           return BuildListView(
//                             item: controller.itemListSearch[index],
//                           );
//                         },
//                       ),
//                     ),
//           ),
//         );
//       },
//     );
//   }
// }
