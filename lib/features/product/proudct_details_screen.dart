import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';
import 'package:voltex/core/constants/images.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/product/product_controller.dart';
import '../../controller/saved/saved_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/model/item_model.dart';
import '../../core/widget/custom_button.dart';
import '../../core/widget/custom_image_widget.dart';
import '../home/widget/customTextField.widgets.dart';
import '../store/widget/product_card.dart';
import 'widget/build_star_rating.dart';
import 'widget/star_rating_input.dart';
import 'widget/static_star_display.dart';

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
      case "MICROWAVES":
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
        return Screenshot(
          controller: productController2.screenshotController,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    savedController.addItem(widget.item);
                    setState(() {});
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
                  SizedBox(
                    height: 210,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child:
                        list.isEmpty
                            ? const Center(child: Text("No images"))
                            : CarouselSlider(
                              options: CarouselOptions(
                                onPageChanged:
                                    (index, _) =>
                                        setState(() => currentPage = index),
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
                  Text(
                    widget.item.itemName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '(${widget.item.brandName})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          StaticStarDisplay(
                            rating:
                                double.tryParse(productController2.rate) ?? 0,
                          ),
                          SizedBox(width: 4),
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
                        onPressed: () => cartControllerImp.addItem(widget.item),
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
                        onPressed:
                            () => cartControllerImp.addItemAndCart(widget.item),
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
                  if (_controller.value.isInitialized)
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        GestureDetector(
                          onTap:
                              () => setState(
                                () =>
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play(),
                              ),
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 15),
                  Text(
                    widget.item.itemDescription,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Ratings & Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StaticStarDisplay(
                        rating: double.tryParse(productController2.rate) ?? 0,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${productController2.rate}/5)',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 200.h,
                      ),
                      itemCount: productController2.listCommints.length,
                      itemBuilder: (context, index) {
                        final comment = productController2.listCommints[index];
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
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
                                          comment.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        StaticStarDisplay(
                                          rating:
                                              double.tryParse(comment.rate) ??
                                              0,
                                        ),
                                        Text(
                                          comment.commint,
                                          style: const TextStyle(fontSize: 14),
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            height: 75.h,
                            margin: const EdgeInsets.only(bottom: 70),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Choose your rating for the product',
                                ),
                                SizedBox(height: 10.h),
                                StarRatingInput(
                                  currentRating: productController2.rateProduct,
                                  onRate: (value) {
                                    setState(() {
                                      productController2.rateProduct = value;
                                    });
                                    productController2.addCommints(
                                      id: widget.item.itemId!,
                                      rates: value,
                                    );
                                    Get.back();
                                    productController2.update();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 180.h,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 130.h,
                      ),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return GestureDetector(
                          onTap: () {
                            productController2.rate = item.rate;
                            productController2.getCommints(id: item.itemId!);
                            Get.to(
                              () => ProductDetailsScreen(
                                item: item,
                                items: widget.items,
                              ),
                            );
                          },
                          child: ProductCard(
                            name: item.itemName,
                            price: item.price,
                            image: item.imageIcon,
                            rate: item.rate,
                            item: item,
                            onPressed: () => cartControllerImp.addItem(item),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
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
