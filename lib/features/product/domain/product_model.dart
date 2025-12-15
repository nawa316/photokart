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
  final int sales;
  final double rating;
  final int reviewCount;

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
    this.sales = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
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
      "sales": sales,
      "rating": rating,
      "reviewCount": reviewCount,
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
      name: map["name"] ?? '',
      description: map["description"] ?? '',
      price: (map["price"] as num?)?.toDouble() ?? 0.0,
      stock: (map["stock"] as int?) ?? 0,
      userId: map["userId"] ?? '',
      imageUrl: map["imageUrl"] ?? '',
      rarity: map["rarity"] ?? 'common',
      createdAt: map["createdAt"] != null 
          ? DateTime.parse(map["createdAt"]) 
          : DateTime.now(),
      sales: (map["sales"] is int) ? map["sales"] as int : (map["sales"] is num ? (map["sales"] as num).toInt() : 0),
      rating: (map["rating"] is num) ? (map["rating"] as num).toDouble() : 0.0,
      reviewCount: (map["reviewCount"] is int)
          ? map["reviewCount"] as int
          : 0,
    );
  }
}