import 'package:flutter/material.dart';
import 'login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _name = 'Nattaya';
  String _email = 'nattaya@gmail.com';
  String _unit = 'กรัม / กิโลกรัม';
  bool _notifExpiry = true;
  bool _notifDaily = true;

  void _editProfile() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขข้อมูลส่วนตัว', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'อีเมล'),
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
                setState(() {
                  _name = nameController.text.isNotEmpty ? nameController.text : _name;
                  _email = emailController.text.isNotEmpty ? emailController.text : _email;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('บันทึกข้อมูลส่วนตัวเรียบร้อยแล้ว')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  void _editNotifications() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('ตั้งค่าการแจ้งเตือน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('แจ้งเตือนอาหารใกล้หมดอายุ'),
                    value: _notifExpiry,
                    activeColor: const Color(0xFF2E7D32),
                    onChanged: (val) {
                      setDialogState(() => _notifExpiry = val);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('สรุปแจ้งเตือนรายวัน'),
                    value: _notifDaily,
                    activeColor: const Color(0xFF2E7D32),
                    onChanged: (val) {
                      setDialogState(() => _notifDaily = val);
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
                  child: const Text('เสร็จสิ้น'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editUnit() {
    final units = ['กรัม / กิโลกรัม', 'ออนซ์ / ปอนด์', 'มิลลิลิตร / ลิตร'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เลือกหน่วยการวัด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: units.map((u) {
              return RadioListTile<String>(
                title: Text(u),
                value: u,
                groupValue: _unit,
                activeColor: const Color(0xFF2E7D32),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _unit = val);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _backupData() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('สำรองข้อมูลสำเร็จเรียบร้อยแล้ว')),
      );
    });
  }

  void _aboutApp() {
    showAboutDialog(
      context: context,
      applicationName: 'FridgeCare',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.kitchen, size: 40, color: Color(0xFF2E7D32)),
      children: const [
        Text('แอปพลิเคชันจัดการตู้เย็น ช่วยจัดการอาหาร ลดการสูญเสีย และประหยัดค่าใช้จ่ายในครัวเรือน'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'ตั้งค่า',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.person, size: 36, color: Color(0xFF2E7D32)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF2E7D32)),
                    onPressed: _editProfile,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Options List
            Container(
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
                children: [
                  _buildSettingsTile(
                    icon: Icons.person_outline,
                    title: 'ข้อมูลส่วนตัว',
                    onTap: _editProfile,
                  ),
                  _buildDivider(),
                  _buildSettingsTile(
                    icon: Icons.notifications_none,
                    title: 'ตั้งค่าการแจ้งเตือน',
                    onTap: _editNotifications,
                  ),
                  _buildDivider(),
                  _buildSettingsTile(
                    icon: Icons.straighten,
                    title: 'หน่วยการวัด',
                    trailing: _unit,
                    onTap: _editUnit,
                  ),
                  _buildDivider(),
                  _buildSettingsTile(
                    icon: Icons.cloud_upload_outlined,
                    title: 'สำรองข้อมูล',
                    onTap: _backupData,
                  ),
                  _buildDivider(),
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    title: 'เกี่ยวกับแอป',
                    onTap: _aboutApp,
                  ),
                  _buildDivider(),
                  _buildSettingsTile(
                    icon: Icons.logout,
                    title: 'ออกจากระบบ',
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    showArrow: false,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? trailing,
    Color textColor = Colors.black87,
    Color iconColor = const Color(0xFF2E7D32),
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          if (trailing != null && showArrow) const SizedBox(width: 8),
          if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16);
  }
}
