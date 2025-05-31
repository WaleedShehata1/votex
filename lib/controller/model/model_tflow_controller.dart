import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/model/food_recipes_model.dart';

class ModelTflowController extends GetxController {
  bool isLoading = true;
  bool loadingModel = true;
  List<File>? images;
  List? _recognitions;
  List foodRecipes = [];
  List<String> fruits = [];
  List<Recipe> listFoodRecipes = [];
  List<Recipe> listFoodRecipesnew = [];
  List<String> urls = [];
  // Load the model and labels
  loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model/model.tflite",
        labels: "assets/model/labels.txt",
      );

      loadingModel = false;
      update();
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> classifyImageFromUrl(String image) async {
    try {
      // Show loading

      OverlayLoadingProgress.start();

      // Step 1: Download the image
      final response = await http.get(Uri.parse(image));
      if (response.statusCode != 200)
        throw Exception("Failed to download image");

      // Step 2: Save image to temp file
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_image.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Step 3: Run inference
      var recognitions = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
        asynch: true,
      );

      // Step 4: Update UI
      _recognitions = recognitions;
      if (_recognitions != null || _recognitions!.isNotEmpty) {
        fruits.add((_recognitions![0]['label']).toString().lowerCamelCase);
      }
      update();
      OverlayLoadingProgress.stop();
      print("Recognition results: $_recognitions");
    } catch (e) {
      print('Error classifying image: $e');
      OverlayLoadingProgress.stop();
    }
  }

  // Find matching recipes based on available ingredients
  List<Recipe> findMatchingRecipes({
    required List<String> available,
    required List<Recipe> recipes,
  }) {
    listFoodRecipesnew =
        recipes.where((recipe) {
          // Return true only if all ingredients are available
          update();
          return recipe.components.every((ingredient) {
            return available.contains(ingredient);
          });
        }).toList();
    update();
    print(listFoodRecipesnew);
    return listFoodRecipesnew;
  }

  // get the images from the folder in Firebase Storage
  Future<void> fetchImagesFromFolder() async {
    final storageRef = FirebaseStorage.instance.ref();
    DateTime now = DateTime.now().toUtc();
    String formattedDate = DateFormat("yyyy-MM-dd").format(now);
    print(formattedDate);
    final folderRef = storageRef
        .child('fruits')
        .child(formattedDate); // replace with your folder

    try {
      final ListResult result = await folderRef.listAll();

      for (var item in result.items) {
        String url = await item.getDownloadURL();

        urls.add(url);
      }

      for (var url in urls) {
        await classifyImageFromUrl(url);
      }
      if (fruits.isNotEmpty) {
        print("fruits= $fruits");
        findMatchingRecipes(available: fruits, recipes: listFoodRecipes);
      }
      isLoading = false;

      update();
    } catch (e) {
      print('Error fetching images: $e');

      isLoading = false;
      update();
    }
  }

  // get the food recipes from Firestore
  Future<void> fetchListFoodRecipes() async {
    listFoodRecipes = [];
    QuerySnapshot listFoodRecipesDB =
        await FirebaseFirestore.instance.collection("foodRecipes").get();

    try {
      for (var element in listFoodRecipesDB.docs) {
        listFoodRecipes.add(
          Recipe.fromJson(element.data() as Map<String, dynamic>),
        );
      }

      update();
    } catch (e) {
      print('Error fetching Food Recipes: $e');

      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    loadModel();
    fetchListFoodRecipes();
    fetchImagesFromFolder();
    super.onInit();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
