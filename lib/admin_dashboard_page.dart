// admin_dashboard_page.dart
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  final String adminName; // untuk menunjukkan siapa yang login

  const AdminDashboardPage({Key? key, required this.adminName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin - $adminName'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.report,
              label: 'Laporan',
              onTap: () {
                Navigator.pushNamed(context, '/laporan');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.schedule,
              label: 'Jadwal CSO',
              onTap: () {
                Navigator.pushNamed(context, '/jadwal');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              SizedBox(height: 10),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
