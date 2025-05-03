import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:voltex/core/constants/images.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/product/product_controller.dart';
import '../../controller/saved/saved_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/helper/route_helper.dart';
import '../../core/model/item_model.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';
import '../home/widget/customTextField.widgets.dart';
import '../store/widget/product_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.item,
    required this.items,
  });
  final ItemModel item;
  final List<ItemModel> items;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final SavedControllerImp savedController = Get.put(SavedControllerImp());
  final CartControllerImp cartControllerImp = Get.put(CartControllerImp());
  late VideoPlayerController _controller;
  final List<ItemModel> items = [];
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  IconData? icon = Icons.favorite_border_outlined;
  String? chosenTexture;
  bool changeModel = false;
  String srcGlb = Images.refrigerator3D;
  List<Widget> list = [];
  @override
  void initState() {
    switch (widget.item.supCategory) {
      case 'بوتجاز':
      case "Stove":
        srcGlb = Images.gasCooker3D;
        break;
      case 'ثلاجة':
      case "Refrigerator":
        srcGlb = Images.refrigerator3D;
        break;
      case 'تكييف':
      case "Air conditioner":
        srcGlb = Images.conditioning3D;
        break;
      case 'ديب فريزر':
      case "Deep freezer":
        srcGlb = Images.deepFreezer3D;
        break;
      case 'سيشوار':
      case "Hair dryer":
        srcGlb = Images.blowDryer3D;
        break;
      case 'شاشة':
      case "Screen TV":
        srcGlb = Images.screen3D;
        break;
      case "غسالة ملابس":
      case "Washing machine":
        srcGlb = Images.washing3D;
        break;
      case "ماكينة صنع قهوة":
      case "Coffee maker":
        srcGlb = Images.coffee3D;
        break;
      case 'مايكروويف':
      case "Microwave":
        srcGlb = Images.microwave3D;
        break;
      case "مروحة حائطية":
      case "Wall fan":
        srcGlb = Images.wallFan3D;
        break;
      case "مروحة عمودية":
      case "Stand fan":
        srcGlb = Images.pillarFan3D;
        break;
      case "مكنسة كهربائية":
      case "Vacuum cleaner":
        srcGlb = Images.vacuumCleaner3D;
        break;
      case "مكواة شعر":
      case "Hair straightener":
        srcGlb = Images.hairStraightener3D;
        break;
      case 'مكواة':
      case "Iron":
        srcGlb = Images.iron3D;
        break;
    }

    // productController.selectsrcGlb(widget.item.supCategory);
    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });

    print(widget.item.videoUrl);
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.item.videoUrl),
      )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    for (var product in widget.items) {
      if (product.supCategory == widget.item.supCategory) {
        items.add(product);
      }
    }
    list = [
      ModelViewer(
        backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: srcGlb,
        autoRotate: true,
      ),
      CustomImageWidget(image: widget.item.imageIcon),
    ];
    super.initState();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController2) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(icon, color: Colors.red),
                onPressed: () {
                  savedController.addItem(widget.item);
                  setState(() {
                    icon = Icons.favorite_outlined;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.reply_rounded, color: Colors.black),
                onPressed: () {
                  productController2.takeScreenshotAndShare(
                    'productName:${widget.item.itemName}\nprice:${widget.item.price}\ndiscount:${widget.item.discount}\ndescription:${widget.item.itemDescription}',
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                SizedBox(
                  height: 210,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {});
                        print(list.length);
                        currentPage = index;
                      },
                      aspectRatio: 1 / 1,
                      height: 160.h,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                    ),
                    items: list,
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(list.length, (index) {
                    return buildDot(
                      index: index,
                      context: context,
                      currentPage: currentPage,
                    );
                  }),
                ),
                const SizedBox(height: 10),

                // Product Title, Rating & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.itemName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '(${widget.item.brandName})',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          (double.parse(productController2.rate)) <= 5 &&
                                  (double.parse(productController2.rate)) >= 1
                              ? Icons.star
                              : (double.parse(productController2.rate)) < 1 &&
                                  (double.parse(productController2.rate)) > 0
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 16,
                        ),
                        Icon(
                          (double.parse(productController2.rate)) <= 5 &&
                                  (double.parse(productController2.rate)) >= 2
                              ? Icons.star
                              : (double.parse(productController2.rate)) < 2 &&
                                  (double.parse(productController2.rate)) > 1
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 16,
                        ),
                        Icon(
                          (double.parse(productController2.rate)) <= 5 &&
                                  (double.parse(productController2.rate)) >= 3
                              ? Icons.star
                              : (double.parse(productController2.rate)) < 3 &&
                                  (double.parse(productController2.rate)) > 2
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 16,
                        ),
                        Icon(
                          (double.parse(productController2.rate)) <= 5 &&
                                  (double.parse(productController2.rate)) >= 4
                              ? Icons.star
                              : (double.parse(productController2.rate)) < 4 &&
                                  (double.parse(productController2.rate)) > 3
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 16,
                        ),
                        Icon(
                          (double.parse(productController2.rate)) == 5
                              ? Icons.star
                              : double.parse(productController2.rate) > 4
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 16,
                        ),
                        Text(
                          '(${productController2.rate}/5)',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        widget.item.price.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'EGP ${(widget.item.price * (1 - (widget.item.discount / 100.0))).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onPressed: () {
                        cartControllerImp.addItem(widget.item);
                      },
                      buttonText: 'Add to cart',
                      boarderColor: AppColors.colorFont,
                      textColor: Colors.white,
                      width: 100.w,
                      height: 30,
                      borderRadius: BorderRadius.circular(10.r),
                      radius: Dimensions.paddingSizeExtremeLarge,
                    ),
                    const SizedBox(width: 5),
                    CustomButton(
                      onPressed: () {
                        cartControllerImp.addItemAndCart(widget.item);
                      },
                      buttonText: 'Buy now',
                      boarderColor: Colors.green,
                      textColor: Colors.white,
                      width: 100.w,
                      height: 30,
                      borderRadius: BorderRadius.circular(10.r),
                      radius: Dimensions.paddingSizeExtremeLarge,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Video Player Section
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Product Description
                Text(
                  widget.item.itemDescription,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 15),

                // Ratings & Reviews Section
                const Text(
                  'Ratings & Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (double.parse(productController2.rate)) <= 5 &&
                              (double.parse(productController2.rate)) >= 1
                          ? Icons.star
                          : (double.parse(productController2.rate)) < 1 &&
                              (double.parse(productController2.rate)) > 0
                          ? Icons.star_half
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Icon(
                      (double.parse(productController2.rate)) <= 5 &&
                              (double.parse(productController2.rate)) >= 2
                          ? Icons.star
                          : (double.parse(productController2.rate)) < 2 &&
                              (double.parse(productController2.rate)) > 1
                          ? Icons.star_half
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Icon(
                      (double.parse(productController2.rate)) <= 5 &&
                              (double.parse(productController2.rate)) >= 3
                          ? Icons.star
                          : (double.parse(productController2.rate)) < 3 &&
                              (double.parse(productController2.rate)) > 2
                          ? Icons.star_half
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Icon(
                      (double.parse(productController2.rate)) <= 5 &&
                              (double.parse(productController2.rate)) >= 4
                          ? Icons.star
                          : (double.parse(productController2.rate)) < 4 &&
                              (double.parse(productController2.rate)) > 3
                          ? Icons.star_half
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Icon(
                      (double.parse(productController2.rate)) == 5
                          ? Icons.star
                          : double.parse(productController2.rate) > 4
                          ? Icons.star_half
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Text(
                      '(${productController2.rate}/5)',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Review Card
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: double.maxFinite,
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 200.h,
                        ),
                        itemCount: productController2.listCommints.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: double.maxFinite,
                            height: 120,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      child: Icon(Icons.person),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productController2
                                                .listCommints[index]
                                                .userName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                (double.parse(
                                                              widget.item.rate,
                                                            )) <=
                                                            5 &&
                                                        (double.parse(
                                                              widget.item.rate,
                                                            )) >=
                                                            1
                                                    ? Icons.star
                                                    : (double.parse(
                                                              widget.item.rate,
                                                            )) <
                                                            1 &&
                                                        (double.parse(
                                                              widget.item.rate,
                                                            )) >
                                                            0
                                                    ? Icons.star_half
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                              Icon(
                                                (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) <=
                                                            5 &&
                                                        (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) >=
                                                            2
                                                    ? Icons.star
                                                    : (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) <
                                                            2 &&
                                                        (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) >
                                                            1
                                                    ? Icons.star_half
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                              Icon(
                                                (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) <=
                                                            5 &&
                                                        (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) >=
                                                            3
                                                    ? Icons.star
                                                    : (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) <
                                                            3 &&
                                                        (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) >
                                                            2
                                                    ? Icons.star_half
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                              Icon(
                                                (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) <=
                                                            5 &&
                                                        (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) >=
                                                            4
                                                    ? Icons.star
                                                    : (double.parse(
                                                              productController2
                                                                  .listCommints[index]
                                                                  .rate,
                                                            )) <
                                                            4 &&
                                                        (double.parse(
                                                              widget.item.rate,
                                                            )) >
                                                            3
                                                    ? Icons.star_half
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                              Icon(
                                                (double.parse(
                                                          productController2
                                                              .listCommints[index]
                                                              .rate,
                                                        )) ==
                                                        5
                                                    ? Icons.star
                                                    : double.parse(
                                                          productController2
                                                              .listCommints[index]
                                                              .rate,
                                                        ) >
                                                        4
                                                    ? Icons.star_half
                                                    : Icons.star_border,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            productController2
                                                .listCommints[index]
                                                .commint,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextFieldChat(
                      controller: productController2.controller,
                      onPress: () {
                        if (productController2.controller.text.isNotEmpty) {
                          Get.bottomSheet(
                            Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                vertical: 15,
                              ),
                              height: 75.h,
                              width: double.maxFinite,
                              margin: EdgeInsetsDirectional.only(bottom: 70),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: [
                                  Text('Choose your rating for the product'),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController2.rateProduct = 1;
                                          });
                                          productController2.addCommints(
                                            id: widget.item.itemId!,
                                            rates: 1,
                                          );
                                          productController2.update();
                                        },
                                        child: Icon(
                                          productController2.rateProduct >= 1
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController2.rateProduct = 2;
                                          });
                                          productController2.addCommints(
                                            id: widget.item.itemId!,
                                            rates: 2,
                                          );
                                          productController2.update();
                                        },
                                        child: Icon(
                                          productController2.rateProduct >= 2
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController2.rateProduct = 3;
                                          });
                                          productController2.addCommints(
                                            id: widget.item.itemId!,
                                            rates: 3,
                                          );
                                          productController2.update();
                                        },
                                        child: Icon(
                                          productController2.rateProduct >= 3
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController2.rateProduct = 4;
                                          });
                                          productController2.addCommints(
                                            id: widget.item.itemId!,
                                            rates: 4,
                                          );
                                          productController2.update();
                                        },
                                        child: Icon(
                                          productController2.rateProduct >= 4
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController2.rateProduct = 5;
                                          });
                                          productController2.addCommints(
                                            id: widget.item.itemId!,
                                            rates: 5,
                                          );
                                          productController2.update();
                                        },
                                        child: Icon(
                                          productController2.rateProduct == 5
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                          productController2.update();
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Product List
                SizedBox(
                  height: 180.h,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      // physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 130.h,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            productController2.rate = items[index].rate;
                            productController2.getCommints(
                              id: items[index].itemId!,
                            );

                            Get.to(
                              ProductDetailsScreen(
                                item: items[index],
                                items: items,
                              ),
                            );
                          },
                          child: ProductCard(
                            name: items[index].itemName,
                            price: items[index].price,
                            image: items[index].imageIcon,
                            rate: items[index].rate,
                            item: items[index],
                            onPressed: () {
                              cartControllerImp.addItem(items[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDot({
    required int index,
    required BuildContext context,
    required int currentPage,
  }) {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: currentPage == index ? 34.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        color:
            currentPage == index
                ? Theme.of(context).primaryColor
                : const Color(0xffa9a9a9),
      ),
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
