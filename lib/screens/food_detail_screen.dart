import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'add_food_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem foodItem;
  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
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

  void _editNote(BuildContext context, FoodItem item) {
    final noteController = TextEditingController(text: item.note);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขโน้ต', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'พิมพ์โน้ตหรือคำแนะนำเกี่ยวกับอาหาร...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                item.note = noteController.text;
                _appState.updateFoodItem(item.id, item);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find current item from appState if updated
    final currentItem = _appState.fridgeItems.firstWhere(
      (i) => i.id == widget.foodItem.id,
      orElse: () => widget.foodItem,
    );

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
          'รายละเอียดอาหาร',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF2E7D32)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFoodScreen(foodItemToEdit: currentItem),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Item Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(currentItem.icon, size: 36, color: const Color(0xFF2E7D32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              currentItem.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                currentItem.category,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${currentItem.quantity} | ${currentItem.location}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'เก็บเมื่อ ${currentItem.storageDate}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Expiry Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'วันหมดอายุ',
                    style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentItem.expiryDate,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        currentItem.status,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: currentItem.statusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.85,
                      backgroundColor: const Color(0xFFF1F1F1),
                      valueColor: AlwaysStoppedAnimation<Color>(currentItem.statusColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Notes Card (Editable)
            GestureDetector(
              onTap: () => _editNote(context, currentItem),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'โน้ต',
                          style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.edit_outlined, size: 16, color: Color(0xFF2E7D32)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentItem.note.isNotEmpty ? currentItem.note : 'แตะเพื่อเพิ่มโน้ต...',
                      style: TextStyle(
                        fontSize: 15,
                        color: currentItem.note.isNotEmpty ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddFoodScreen(foodItemToEdit: currentItem),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'แก้ไขข้อมูล',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        _appState.removeFoodItem(currentItem.id);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'ลบรายการ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
