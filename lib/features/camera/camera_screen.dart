import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/camera/camera_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';
import '../model/models_tflow_screen.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Images')),
          body:
              controller.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: double.maxFinite,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5.h,
                                  crossAxisSpacing: 5.w,
                                ),

                            itemCount:
                                controller.imageUrls.isEmpty
                                    ? 4
                                    : controller.imageUrls.length,
                            itemBuilder: (context, index) {
                              return controller.imageUrls.isEmpty
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: CustomImageWidget(
                                        image: controller.imageUrls[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                            },
                          ),
                        ),
                        controller.imageUrls.isEmpty
                            ? SizedBox()
                            : Column(
                              children: [
                                Text(
                                  'You can find out recipes that can be made with the available ingredients.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CustomButton(
                                  onPressed: () {
                                    Get.to(ModelsTflowScreen());
                                  },
                                  buttonText: 'Food recipes',
                                  boarderColor: AppColors.colorFont,
                                  textColor: Colors.white,
                                  width: 150.w,
                                  height: 35.h,
                                  borderRadius: BorderRadius.circular(10.r),
                                  radius: Dimensions.paddingSizeExtremeLarge,
                                ),
                              ],
                            ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
