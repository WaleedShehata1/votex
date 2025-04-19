import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:votex/core/constants/images.dart';
import '../../controller/cart/cart_controller.dart';
import '../../controller/product/product_controller.dart';
import '../../controller/saved/saved_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimensions.dart';
import '../../core/helper/route_helper.dart';
import '../../core/model/item_model.dart';
import '../../core/widget/custom_button.dart';
import '../store/widget/product_card.dart';

final SavedControllerImp savedController = Get.put(
  SavedControllerImp(),
);

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, required this.item, required this.items});
  final ItemModel item;
  final List<ItemModel> items;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductController productController = Get.put(
    ProductController(),
  );
  final CartControllerImp cartControllerImp = Get.put(
    CartControllerImp(),
  );
  late VideoPlayerController _controller;
  final List<ItemModel> items = [];
  Flutter3DController controller = Flutter3DController();
  String? chosenAnimation;
  IconData? icon = Icons.favorite_border_outlined;
  String? chosenTexture;
  bool changeModel = false;
  String srcGlb = Images.refrigerator3D;
  @override
  void initState() {
    switch (widget.item.supCategory) {
      case 'بوتجازات':
        srcGlb = Images.gasCooker3D;
        break;
      case 'ثلاجات':
        srcGlb = Images.refrigerator3D;
        break;
      case 'تكييفات':
        srcGlb = Images.conditioning3D;
        break;
      case 'ديب فريزر':
        srcGlb = Images.deepFreezer3D;
        break;
      case 'سيشوار':
        srcGlb = Images.blowDryer3D;
        break;
      case 'شاشة':
        srcGlb = Images.screen3D;
        break;
      case 'غسالة راسية':
        srcGlb = Images.washing3D;
        break;
      case 'ماكينة قهوة':
        srcGlb = Images.coffee3D;
        break;
      case 'مايكروويف':
        srcGlb = Images.microwave3D;
        break;
      case 'مرواحة حائط':
        srcGlb = Images.wallFan3D;
        break;
      case 'مرواحة عمود.':
        srcGlb = Images.pillarFan3D;
        break;
      case 'مكنسة كهربائية.':
        srcGlb = Images.vacuumCleaner3D;
        break;
      case 'مكواة شعر.':
        srcGlb = Images.hairStraightener3D;
        break;
      case 'مكواة':
        srcGlb = Images.iron3D;
        break;
      // default:
      //   srcGlb = Images.gasCooker3D;
      //   break;
    }

    // productController.selectImage3D(widget.item.supCategory);
    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });

    print(widget.item.videoUrl);
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.item.videoUrl,
      ),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    for (var product in widget.items) {
      if (product.supCategory == widget.item.supCategory) {
        items.add(product);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                // for (var element in savedController.savedItems) {
                //   if (element.itemId == widget.item.itemId) {
                //     savedController.removed(widget.item);
                //     icon = Icons.favorite_outlined;
                //   }
                // }
                icon = Icons.favorite_outlined;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.reply_rounded, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Image
            Center(
              // child: Image.asset(
              //   Images.gasCooker,
              //   height: 200,
              //   fit: BoxFit.contain,
              // ),
              child: SizedBox(
                height: 200,
                width: 250,
                child: ModelViewer(
                  backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                  src: srcGlb,
                  autoRotate: true,
                ),
              ),
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
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(${widget.item.brandName})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star_half, color: Colors.orange, size: 16),
                    Text('(${widget.item.rate}/5)',
                        style: const TextStyle(color: Colors.blue)),
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
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                      'EGP ${widget.item.price * (1 - (widget.item.discount / 100.0))}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
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
                const SizedBox(
                  width: 5,
                ),
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

            // Product Variations (Images)
            // SizedBox(
            //   height: 60,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: List.generate(
            //       4,
            //       (index) => Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 5),
            //         child: Image.asset(
            //           Images.gasCooker,
            //           width: 50,
            //           height: 50,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 15),

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
            // const Row(
            //   children: [
            //     Icon(Icons.star, color: Colors.orange, size: 20),
            //     Icon(Icons.star, color: Colors.orange, size: 20),
            //     Icon(Icons.star, color: Colors.orange, size: 20),
            //     Icon(Icons.star, color: Colors.orange, size: 20),
            //     Icon(Icons.star_half, color: Colors.orange, size: 20),
            //     SizedBox(width: 5),
            //     Text('4/5',
            //         style: TextStyle(fontSize: 14, color: Colors.black54)),
            //   ],
            // ),

            const SizedBox(height: 10),

            // Review Card
            Container(
              width: double.maxFinite, height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              // child: const Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     CircleAvatar(
              //       radius: 20,
              //       child: Icon(Icons.person),
              //     ),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Mohamed Ahmed',
              //             style: TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //           Row(
              //             children: [
              //               Icon(Icons.star, color: Colors.orange, size: 18),
              //               Icon(Icons.star, color: Colors.orange, size: 18),
              //               Icon(Icons.star, color: Colors.orange, size: 18),
              //               Icon(Icons.star, color: Colors.orange, size: 18),
              //               Icon(Icons.star_half,
              //                   color: Colors.orange, size: 18),
              //             ],
              //           ),
              //           Text(
              //             "Great washing machine, easy to use and energy-efficient!",
              //             style: TextStyle(fontSize: 14),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ),

            SizedBox(height: 20.h),

            // Product List
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 168.h,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.toNamed(RouteHelper.productDetailsScreen),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
