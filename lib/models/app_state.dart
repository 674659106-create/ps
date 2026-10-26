import 'package:flutter/material.dart';

class FoodItem {
  String id;
  String name;
  String category;
  String quantity;
  String location;
  String storageDate;
  String expiryDate;
  String status;
  Color statusColor;
  IconData icon;
  String note;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.location,
    required this.storageDate,
    required this.expiryDate,
    required this.status,
    required this.statusColor,
    required this.icon,
    this.note = 'ควรปรุงให้สุกก่อนรับประทาน',
  });
}

class ShoppingItem {
  String id;
  String name;
  String detail;
  bool isBought;
  IconData icon;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.detail,
    required this.isBought,
    required this.icon,
  });
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  List<FoodItem> fridgeItems = [
    FoodItem(
      id: '1',
      name: 'ผักกาดหอม',
      category: 'ผัก',
      quantity: '1 หัว',
      location: 'ช่องผักผลไม้',
      storageDate: '9 พ.ค. 2567',
      expiryDate: '14 พ.ค. 2567',
      status: 'เหลือ 5 วัน',
      statusColor: Colors.green,
      icon: Icons.eco,
      note: 'ล้างน้ำให้สะอาดก่อนเก็บ',
    ),
    FoodItem(
      id: '2',
      name: 'มะเขือเทศ',
      category: 'ผัก',
      quantity: '3 ลูก',
      location: 'ช่องแช่เย็น',
      storageDate: '11 พ.ค. 2567',
      expiryDate: '16 พ.ค. 2567',
      status: 'เหลือ 5 วัน',
      statusColor: Colors.green,
      icon: Icons.eco,
      note: 'เก็บในกล่องสุญญากาศ',
    ),
    FoodItem(
      id: '3',
      name: 'แอปเปิล',
      category: 'ผักผลไม้',
      quantity: '4 ลูก',
      location: 'ช่องแช่เย็น',
      storageDate: '11 พ.ค. 2567',
      expiryDate: '20 พ.ค. 2567',
      status: 'เหลือ 9 วัน',
      statusColor: Colors.green,
      icon: Icons.apple,
      note: 'ห้ามวางใกล้กล้วย',
    ),
    FoodItem(
      id: '4',
      name: 'เนื้อวัว',
      category: 'เนื้อสัตว์',
      quantity: '500 กรัม',
      location: 'ช่องแช่แข็ง',
      storageDate: '11 พ.ค. 2567',
      expiryDate: '18 พ.ค. 2567',
      status: 'เหลือ 7 วัน',
      statusColor: Colors.orange,
      icon: Icons.set_meal,
      note: 'แบ่งแพ็กละ 250 กรัม',
    ),
    FoodItem(
      id: '5',
      name: 'นมสด',
      category: 'เครื่องดื่ม',
      quantity: '2 แกลลอน',
      location: 'ประตูตู้เย็น',
      storageDate: '10 พ.ค. 2567',
      expiryDate: '13 พ.ค. 2567',
      status: 'เหลือ 2 วัน',
      statusColor: Colors.orange,
      icon: Icons.local_drink,
      note: 'ดื่มให้หมดก่อนวันหมดอายุ',
    ),
    FoodItem(
      id: '6',
      name: 'อกไก่',
      category: 'เนื้อสัตว์',
      quantity: '500 กรัม',
      location: 'ช่องแช่เย็น',
      storageDate: '11 พ.ค. 2567',
      expiryDate: '13 พ.ค. 2567',
      status: 'เหลือ 1 วัน',
      statusColor: Colors.deepOrange,
      icon: Icons.set_meal,
      note: 'ควรปรุงให้สุกก่อนรับประทาน',
    ),
  ];

  List<ShoppingItem> shoppingItems = [
    ShoppingItem(id: '1', name: 'นมสด', detail: '2 แกลลอน', isBought: false, icon: Icons.local_drink),
    ShoppingItem(id: '2', name: 'ไข่ไก่', detail: '1 แพ็ก', isBought: false, icon: Icons.egg),
    ShoppingItem(id: '3', name: 'มะเขือเทศ', detail: '3 ลูก', isBought: true, icon: Icons.eco),
    ShoppingItem(id: '4', name: 'ผักกาดหอม', detail: '1 หัว', isBought: true, icon: Icons.grass),
    ShoppingItem(id: '5', name: 'แครอท', detail: '500 กรัม', isBought: false, icon: Icons.spa),
  ];

  int get totalItems => fridgeItems.length;
  int get nearExpiryItemsCount => fridgeItems.where((item) => item.status.contains('วัน')).length;
  int get expiredItemsCount => 0;

  void addFoodItem(FoodItem item) {
    fridgeItems.add(item);
    notifyListeners();
  }

  void updateFoodItem(String id, FoodItem updatedItem) {
    final index = fridgeItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      fridgeItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void removeFoodItem(String id) {
    fridgeItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void addShoppingItem(ShoppingItem item) {
    shoppingItems.add(item);
    notifyListeners();
  }

  void toggleShoppingItem(String id) {
    final item = shoppingItems.firstWhere((i) => i.id == id);
    item.isBought = !item.isBought;
    notifyListeners();
  }
}
