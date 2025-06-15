import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final Map<String, Map<String, bool>> checklist = {
    'Area Kelas': {
      'Menyapu lantai': false,
      'Mengepel lantai': false,
      'Membersihkan meja dan kursi': false,
    },
    'Gedung Bagian Dalam': {
      'Membersihkan tralis, dinding dan lantai': false,
      'Menyapu lantai': false,
      'Mengepel lantai': false,
      'Membersihkan Tangga': false,
      'Membersihkan Plafon': false,
      'Membersihkan Jendela Kaca': false,
      'Membersihkan Dinding dari noda': false,
      'Membersihkan Meja Wastafel': false,
      'Menyiram Tanaman': false,
      'Merapikan dan Membersihkan Tanaman': false,
      'Membuang Sampah': false,
      'Memasang Plastik Sampah': false,
      'Membersihkan Tempat Sampah': false,
    },
    'Gedung Bagian Luar': {
      'Membersihkan kaca jendela': false,
      'Membersihkan atap': false,
      'Menyiram tanaman': false,
      'Merapihkan dan Membersihkan Tanaman': false,
      'Memasang Plastik Sampah': false,
      'Membersihkan Tempat Sampah': false,
    },
  };

  void kirimTugasHarian() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tugas harian berhasil dikirim!")),
    );

    setState(() {
      for (var kategori in checklist.keys) {
        for (var tugas in checklist[kategori]!.keys) {
          checklist[kategori]![tugas] = false;
        }
      }
    });
  }

  bool adaYangDicentang() {
    for (var kategori in checklist.values) {
      if (kategori.containsValue(true)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: checklist.entries.map((entry) {
              return Card(
                margin: EdgeInsets.all(12),
                child: ExpansionTile(
                  title: Text(entry.key,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: entry.value.keys.map((task) {
                    return CheckboxListTile(
                      title: Text(task),
                      value: entry.value[task],
                      onChanged: (val) {
                        setState(() {
                          entry.value[task] = val!;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              if (!adaYangDicentang()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Belum ada tugas yang dicentang")),
                );
              } else {
                kirimTugasHarian();
              }
            },
            icon: Icon(Icons.send),
            label: Text("Kirim Tugas Harian"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }
}
