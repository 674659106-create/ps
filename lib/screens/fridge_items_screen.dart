import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'add_food_screen.dart';
import 'food_detail_screen.dart';

class FridgeItemsScreen extends StatefulWidget {
  const FridgeItemsScreen({super.key});

  @override
  State<FridgeItemsScreen> createState() => _FridgeItemsScreenState();
}

class _FridgeItemsScreenState extends State<FridgeItemsScreen> {
  String _selectedCategory = 'ทั้งหมด';
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    setState(() {});
  }

  final List<String> _categories = ['ทั้งหมด', 'ผัก', 'ผักผลไม้', 'เนื้อสัตว์', 'เครื่องดื่ม'];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'ทั้งหมด'
        ? _appState.fridgeItems
        : _appState.fridgeItems.where((item) => item.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'รายการในตู้เย็น',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ค้นหาอาหารในตู้เย็น',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Color(0xFF2E7D32), size: 20),
                ),
              ],
            ),
          ),

          // Category Chips
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: const Color(0xFF2E7D32),
                    backgroundColor: const Color(0xFFF5F5F5),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Items List
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('ไม่พบรายการอาหารในหมวดหมู่นี้', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(foodItem: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(item.icon, color: const Color(0xFF2E7D32)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            item.category,
                                            style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'หมดอายุ ${item.expiryDate}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: item.statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.status,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: item.statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  _appState.removeFoodItem(item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Add Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddFoodScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'เพิ่มรายการอาหาร',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
