class ProductModel {
  final String? id; // Change from int? to String?
  final String name;
  final String description;
  final double price;
  final int stock;
  final String userId;
  final String imageUrl;
  final String rarity;
  final DateTime createdAt;

  ProductModel({
    this.id, // Now accepts String
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.userId,
    required this.imageUrl,
    required this.rarity,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert ProductModel to map for Supabase insert
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "name": name,
      "description": description,
      "price": price,
      "stock": stock,
      "userId": userId,
      "imageUrl": imageUrl,
      "rarity": rarity,
      "createdAt": createdAt.toIso8601String(),
    };
    
    // Only include id if it exists (for updates)
    if (id != null) {
      map["id"] = id;
    }
    
    return map;
  }

  /// Create ProductModel from Supabase response
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"]?.toString(), // Convert to string
      name: map["name"],
      description: map["description"],
      price: (map["price"] as num).toDouble(),
      stock: map["stock"],
      userId: map["user_id"],
      imageUrl: map["image_url"],
      rarity: map["rarity"] ?? 'common',
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}