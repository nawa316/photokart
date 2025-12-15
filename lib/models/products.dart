import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double rating;
  final int reviewCount;
  final int stock;
  final int sales;
  final String priceLabel;
  final List<Color> gradientColors;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.sales,
    required this.priceLabel,
    required this.gradientColors,
  });

  String get formattedPrice => priceLabel;

  static getById(String id) {
    return products.firstWhere(
      (p) => p.id == id,
      orElse: () => products.first,
    );
  }
}

const List<Product> products = [
  Product(
    id: '1',
    name: 'Hanni Bengong',
    description: 'Photocard Rare',
    image: 'assets/images/hanni.png',
    rating: 4.9,
    reviewCount: 120,
    stock: 6,
    sales: 200,
    priceLabel: 'RP. 120.000,00',
    gradientColors: [
      Color(0xFFFDE7EA),
      Color(0xFFFFECEF),
    ],
  ),
  Product(
    id: '2',
    name: 'Suzi',
    description: 'Photocard Rare',
    image: 'assets/images/suzi.png',
    rating: 4.7,
    reviewCount: 120,
    stock: 6,
    sales: 150,
    priceLabel: 'RP. 120.000,00',
    gradientColors: [
      Color(0xFFFEE6F6),
      Color(0xFFFFF0FB),
    ],
  ),
  Product(
    id: '3',
    name: 'Karina Dagu',
    description: 'Photocard Rare',
    image: 'assets/images/karina.png',
    rating: 4.7,
    reviewCount: 120,
    stock: 6,
    sales: 100,
    priceLabel: 'RP. 120.000,00',
    gradientColors: [
      Color(0xFFE5F3FF),
      Color(0xFFF1F8FF),
    ],
  ),
  Product(
    id: '4',
    name: 'Ahul IndoKor',
    description: 'Photocard Rare',
    image: 'assets/images/ahul.png',
    rating: 4.0,
    reviewCount: 12000,
    stock: 6,
    sales: 50,
    priceLabel: 'RP. 100.200.000,00',
    gradientColors: [
      Color(0xFFF4E7FF),
      Color(0xFFF9F0FF),
    ],
  ),
];
