import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voltex/features/recipes/recipe_screen.dart';

import '../../controller/model/model_tflow_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';

class ModelsTflowScreen extends StatelessWidget {
  const ModelsTflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('food Recipes')),
      body: GetBuilder<ModelTflowController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("components", style: TextStyle(fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children:
                          controller.fruits.map((f) {
                            return Text(f, style: TextStyle(fontSize: 16));
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text("Recipes", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: double.maxFinite,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5.h,
                        crossAxisSpacing: 5.w,
                      ),

                      itemCount:
                          controller.listFoodRecipesnew.isEmpty
                              ? 4
                              : controller.listFoodRecipesnew.length,
                      itemBuilder: (context, index) {
                        return controller.listFoodRecipesnew.isEmpty
                            ? Container(
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: Text(
                                'empty',
                                style: TextStyle(fontSize: 28.sp),
                                textAlign: TextAlign.center,
                              ),
                            )
                            : Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    RecipeScreen(
                                      data:
                                          controller.listFoodRecipesnew[index],
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Stack(
                                    fit: StackFit.expand,

                                    children: [
                                      CustomImageWidget(
                                        image:
                                            controller
                                                .listFoodRecipesnew[index]
                                                .imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.bottomCenter,
                                          child: Text(
                                            controller
                                                .listFoodRecipes[index]
                                                .name,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
