import 'package:flutter/material.dart';

class JadwalPage extends StatelessWidget {
  final Map<String, List<String>> jadwal = {
    'Area Kelas': [
      'Menyapu lantai',
      'Mengepel lantai',
      'Membersihkan dan Mengelap Meja + Kursi',
      'Membersihkan Langit langit',
      'Mengelap Kaca dan Dinding'
    ],
    'Gedung Bagian Dalam': [
      'Membersihkan Tralis, Dinding dan Lantai',
      'Menyapu lantai',
      'Mengepel lantai',
      'Membersihkan Tangga',
      'Membersihkan Plafon',
      'Membersihkan Jendela Kaca',
      'Membersihkan Dinding dari noda',
      'Membersihkan Meja Wastafel',
      'Menyiram Tanaman',
      'Merapikan dan Membersihkan Tanaman',
      'Membuang Sampah',
      'Memasang Plastik Sampah',
      'Membersihkan Tempat Sampah'
    ],
    'Gedung Bagian Luar': [
      'Membersihkan kaca jendela',
      'Membersihkan atap',
      'Menyiram tanaman',
      'Merapihkan dan Membersihkan Tanaman',
      'Memasang Plastik Sampah',
      'Membersihkan Tempat Sampah'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: jadwal.entries.map((entry) {
        return Card(
          margin: EdgeInsets.all(12),
          child: ExpansionTile(
            title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
            children: entry.value.map((task) => ListTile(title: Text(task))).toList(),
          ),
        );
      }).toList(),
    );
  }
}
