import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final int sales;
  final double rating;
  final int reviewCount;
  final String image;
  final Color color;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.sales,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.color,
  });

  // Format price to Indonesian Rupiah format
  String get formattedPrice {
    return 'RP. ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )},00';
  }

  // Sample data
  static List<Product> sampleProducts = [
    Product(
      id: '1',
      name: 'Hanni Bengong',
      description: 'Photocard Rare',
      price: 120000,
      stock: 6,
      sales: 200,
      rating: 4.9,
      reviewCount: 120,
      image: 'assets/images/hanni.jpg',
      color: const Color(0xFFE6E6FA),
    ),
    Product(
      id: '2',
      name: 'Jungkook',
      description: 'Photocard Rare',
      price: 150000,
      stock: 3,
      sales: 150,
      rating: 4.8,
      reviewCount: 95,
      image: 'assets/images/jungkook.jpg', 
      color: const Color(0xFFE8EAF6),
    ),
    Product(
      id: '3',
      name: 'Karina',
      description: 'Photocard Super Rare',
      price: 1800000,
      stock: 1,
      sales: 180,
      rating: 5.0,
      reviewCount: 200,
      image: 'assets/images/karina.jpg',
      color: const Color(0xFFF3E5F5),
    ),
    Product(
      id: '4',
      name: 'Suzi',
      description: 'Photocard Rare',
      price: 135000,
      stock: 8,
      sales: 220,
      rating: 4.7,
      reviewCount: 85,
      image: 'assets/images/suzi.jpg',
      color: const Color(0xFFFCE4EC),
    ),
    Product(
      id: '5',
      name: 'Ahul',
      description: 'Photocard Uber Rare',
      price: 20000000,
      stock: 1,
      sales: 90,
      rating: 5.0,
      reviewCount: 110,
      image: 'assets/images/ahul.jpg',
      color: const Color(0xFFEDE7F6),
    ),
  ];
}