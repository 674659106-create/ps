import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _selectedFilter = 'ทั้งหมด (5)';

  final List<Map<String, dynamic>> _shoppingItems = [
    {
      'name': 'นมสด',
      'detail': '2 แกลลอน',
      'isBought': false,
      'icon': Icons.local_drink,
    },
    {
      'name': 'ไข่ไก่',
      'detail': '1 แพ็ก',
      'isBought': false,
      'icon': Icons.egg,
    },
    {
      'name': 'มะเขือเทศ',
      'detail': '3 ลูก',
      'isBought': true,
      'icon': Icons.eco,
    },
    {
      'name': 'ผักกาดหอม',
      'detail': '1 หัว',
      'isBought': true,
      'icon': Icons.grass,
    },
    {
      'name': 'แครอท',
      'detail': '500 กรัม',
      'isBought': false,
      'icon': Icons.spa,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _shoppingItems.where((item) {
      if (_selectedFilter.contains('ยังไม่ได้ซื้อ')) return !item['isBought'];
      if (_selectedFilter.contains('ซื้อแล้ว')) return item['isBought'];
      return true;
    }).toList();

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
          'รายการที่ต้องซื้อ',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF2E7D32)),
            onPressed: () {
              _showAddShoppingItemDialog(context);
            },
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
                      hintText: 'ค้นหารายการที่ต้องซื้อ',
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

          // Filter Chips
          Container(
            height: 50,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('ทั้งหมด (5)'),
                const SizedBox(width: 8),
                _buildFilterChip('ยังไม่ได้ซื้อ (3)'),
                const SizedBox(width: 8),
                _buildFilterChip('ซื้อแล้ว (2)'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Shopping Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Container(
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
                        child: Icon(item['icon'], color: const Color(0xFF2E7D32)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: item['isBought'] ? Colors.grey : Colors.black87,
                                decoration: item['isBought'] ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['detail'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: item['isBought'],
                        activeColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            item['isBought'] = value ?? false;
                          });
                        },
                      ),
                    ],
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
                  _showAddShoppingItemDialog(context);
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
                  'เพิ่มรายการที่ต้องซื้อ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = label == _selectedFilter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
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
    );
  }

  void _showAddShoppingItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final detailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เพิ่มรายการที่ต้องซื้อ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailController,
                decoration: const InputDecoration(labelText: 'จำนวน/รายละเอียด'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _shoppingItems.add({
                      'name': nameController.text,
                      'detail': detailController.text.isNotEmpty ? detailController.text : '1 ชิ้น',
                      'isBought': false,
                      'icon': Icons.shopping_bag,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
              child: const Text('เพิ่ม'),
            ),
          ],
        );
      },
    );
  }
}
