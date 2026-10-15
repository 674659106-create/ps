import 'package:flutter/material.dart';
import '../models/app_state.dart';

class AddFoodScreen extends StatefulWidget {
  final FoodItem? foodItemToEdit;
  const AddFoodScreen({super.key, this.foodItemToEdit});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _noteController;
  late String _selectedCategory;
  late String _selectedLocation;
  late String _storageDate;
  late String _expiryDate;
  final AppState _appState = AppState();

  final List<String> _categories = ['เนื้อสัตว์', 'ผักผลไม้', 'เครื่องดื่ม', 'นมและผลิตภัณฑ์นม', 'ผัก', 'อื่นๆ'];
  final List<String> _locations = ['ช่องแช่เย็น', 'ช่องแช่แข็ง', 'ช่องผักผลไม้', 'ประตูตู้เย็น'];

  @override
  void initState() {
    super.initState();
    final item = widget.foodItemToEdit;
    _nameController = TextEditingController(text: item != null ? item.name : '');
    _quantityController = TextEditingController(text: item != null ? item.quantity : '500 กรัม');
    _noteController = TextEditingController(text: item != null ? item.note : 'ควรนำไปทำอาหารก่อนวันหมดอายุ');
    _selectedCategory = item != null ? item.category : 'เนื้อสัตว์';
    _selectedLocation = item != null ? item.location : 'ช่องแช่เย็น';
    _storageDate = item != null ? item.storageDate : '11 พ.ค. 2567';
    _expiryDate = item != null ? item.expiryDate : '16 พ.ค. 2567';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStorageDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final months = [
          'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
          'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
        ];
        final day = picked.day;
        final month = months[picked.month - 1];
        final year = picked.year + 543;
        final formattedDate = '$day $month $year';

        if (isStorageDate) {
          _storageDate = formattedDate;
        } else {
          _expiryDate = formattedDate;
        }
      });
    }
  }

  void _saveFood() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (widget.foodItemToEdit != null) {
      final updated = FoodItem(
        id: widget.foodItemToEdit!.id,
        name: name,
        category: _selectedCategory,
        quantity: _quantityController.text,
        location: _selectedLocation,
        storageDate: _storageDate,
        expiryDate: _expiryDate,
        status: 'เหลือ 5 วัน',
        statusColor: Colors.green,
        icon: widget.foodItemToEdit!.icon,
        note: _noteController.text,
      );
      _appState.updateFoodItem(widget.foodItemToEdit!.id, updated);
    } else {
      final newItem = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        category: _selectedCategory,
        quantity: _quantityController.text,
        location: _selectedLocation,
        storageDate: _storageDate,
        expiryDate: _expiryDate,
        status: 'เหลือ 5 วัน',
        statusColor: Colors.green,
        icon: Icons.kitchen,
        note: _noteController.text,
      );
      _appState.addFoodItem(newItem);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.foodItemToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'แก้ไขข้อมูลอาหาร' : 'เพิ่มอาหาร',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image Placeholder
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.set_meal, size: 50, color: Color(0xFF2E7D32)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Food Name
            const Text('ชื่ออาหาร', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'เช่น อกไก่',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category & Storage Date Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('หมวดหมู่', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: _categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('วันที่เก็บ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context, true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_storageDate, style: const TextStyle(fontSize: 14)),
                              const Icon(Icons.calendar_today, size: 18, color: Color(0xFF2E7D32)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expiry Date
            const Text('วันหมดอายุ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, false),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_expiryDate, style: const TextStyle(fontSize: 14)),
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF2E7D32)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quantity & Location Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('จำนวน', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: '500 กรัม',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('สถานที่เก็บ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLocation,
                            isExpanded: true,
                            items: _locations.map((loc) {
                              return DropdownMenuItem(
                                value: loc,
                                child: Text(loc, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedLocation = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Note Field
            const Text('โน้ต / คำแนะนำ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'เช่น ควรปรุงให้สุกก่อนรับประทาน',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Save / Update Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isEditing ? 'บันทึกการแก้ไข' : 'บันทึก',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
