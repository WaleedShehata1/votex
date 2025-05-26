class Recipe {
  final String name;
  final String description;
  final int cookingTime;
  final int numberOfIndividuals;
  final String imageUrl;
  final List<String> components;
  final List<Ingredient> ingredients;
  final List<String> preparationMethod;

  Recipe({
    required this.name,
    required this.description,
    required this.cookingTime,
    required this.numberOfIndividuals,
    required this.imageUrl,
    required this.components,
    required this.ingredients,
    required this.preparationMethod,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      description: json['description'],
      cookingTime: json['Cooking time'],
      numberOfIndividuals: json['Number of individuals'],
      imageUrl: json['image_url'],
      components: List<String>.from(json['components']),
      ingredients: List<Ingredient>.from(
        json['Ingredients'].map((x) => Ingredient.fromJson(x)),
      ),
      preparationMethod: List<String>.from(json['Preparation method']),
    );
  }
}

class Ingredient {
  final String amount;
  final String component;

  Ingredient({required this.amount, required this.component});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(amount: json['Amount'], component: json['Component']);
  }
}
