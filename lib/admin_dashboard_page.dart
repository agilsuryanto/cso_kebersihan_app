import 'package:cso_kebersihan_app/main.dart';
import 'placeholder_page.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  final String adminName;
  final VoidCallback? toggleTheme; // Made optional with nullable type

  const AdminDashboardPage({
    Key? key,
    required this.adminName,
    this.toggleTheme, // Optional parameter
  }) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<Widget> _pages = [
    DashboardSummary(),
    AdminChecklistPage(), // Changed from PlaceholderPage
    AdminLaporanPage(),   // Changed from PlaceholderPage
    PlaceholderPage(title: 'Manajemen Akun'),
  ];

  int _currentIndex = 0;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage(toggleTheme: widget.toggleTheme ?? () {})),
                    (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  final List<String> _titles = [
    'Dashboard Admin',
    'Checklist CSO',
    'Laporan Kerusakan',
    'Manajemen Akun'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            SizedBox(width: 10),
            Text(
              _titles[_currentIndex],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Add theme toggle button if toggleTheme is available
          if (widget.toggleTheme != null)
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Added to support 4 items
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Checklist'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Akun'),
        ],
      ),
    );
  }
}

// ==================== ADMIN JADWAL PAGE ====================
class AdminJadwalPage extends StatelessWidget {
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jadwal tugas harian untuk semua CSO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: jadwal.entries.map((entry) {
              return Card(
                margin: EdgeInsets.all(12),
                child: ExpansionTile(
                  title: Text(
                    entry.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: entry.value.map((task) =>
                      ListTile(
                        leading: Icon(Icons.task, color: Colors.green),
                        title: Text(task),
                      )
                  ).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ==================== ADMIN CHECKLIST PAGE ====================
class AdminChecklistPage extends StatelessWidget {
  // Data simulasi checklist yang dikirim oleh CSO
  final List<Map<String, dynamic>> checklistTugas = [
    {
      'pengirim': 'cso_user1',
      'tanggal': '2024-12-05',
      'waktu': '08:30',
      'tugas': [
        {'nama': 'Menyapu lantai kelas', 'selesai': true},
        {'nama': 'Mengepel lantai kantor', 'selesai': true},
        {'nama': 'Membersihkan meja guru', 'selesai': false},
      ]
    },
    {
      'pengirim': 'cso_user2',
      'tanggal': '2024-12-05',
      'waktu': '09:15',
      'tugas': [
        {'nama': 'Membersihkan kaca jendela', 'selesai': true},
        {'nama': 'Menyiram tanaman', 'selesai': true},
        {'nama': 'Membersihkan tempat sampah', 'selesai': true},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              Icon(Icons.assignment_turned_in, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Checklist tugas yang dikirim oleh CSO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: checklistTugas.length,
            itemBuilder: (context, index) {
              final checklist = checklistTugas[index];
              final totalTugas = checklist['tugas'].length;
              final tugasSelesai = checklist['tugas'].where((tugas) => tugas['selesai'] == true).length;

              return Card(
                margin: EdgeInsets.all(12),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.person, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pengirim: ${checklist['pengirim']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${checklist['tanggal']} - ${checklist['waktu']}'),
                      SizedBox(height: 4),
                      Text(
                        'Progress: $tugasSelesai/$totalTugas tugas selesai',
                        style: TextStyle(
                          color: tugasSelesai == totalTugas ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  children: checklist['tugas'].map<Widget>((tugas) {
                    return ListTile(
                      leading: Icon(
                        tugas['selesai'] ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: tugas['selesai'] ? Colors.green : Colors.grey,
                      ),
                      title: Text(tugas['nama']),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: tugas['selesai'] ? Colors.green.shade100 : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tugas['selesai'] ? 'Selesai' : 'Belum',
                          style: TextStyle(
                            color: tugas['selesai'] ? Colors.green.shade800 : Colors.orange.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==================== ADMIN LAPORAN PAGE ====================
class AdminLaporanPage extends StatefulWidget {
  @override
  _AdminLaporanPageState createState() => _AdminLaporanPageState();
}

class _AdminLaporanPageState extends State<AdminLaporanPage> {
  // Data simulasi laporan yang dikirim oleh CSO
  List<Map<String, dynamic>> laporanKerusakan = [
    {
      'pengirim': 'cso_user1',
      'tanggal': '2024-12-05',
      'waktu': '10:30',
      'deskripsi': 'Kipas angin rusak di kelas 7A',
      'ditindaklanjuti': false,
    },
    {
      'pengirim': 'cso_user2',
      'tanggal': '2024-12-05',
      'waktu': '11:15',
      'deskripsi': 'Kaca pecah di lantai 2',
      'ditindaklanjuti': true,
    },
    {
      'pengirim': 'cso_user1',
      'tanggal': '2024-12-05',
      'waktu': '14:20',
      'deskripsi': 'Sampah menumpuk di taman belakang',
      'ditindaklanjuti': false,
    },
  ];

  void toggleTindakLanjut(int index) {
    setState(() {
      laporanKerusakan[index]['ditindaklanjuti'] = !laporanKerusakan[index]['ditindaklanjuti'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            laporanKerusakan[index]['ditindaklanjuti']
                ? 'Laporan ditandai sebagai ditindaklanjuti'
                : 'Laporan ditandai sebagai belum ditindaklanjuti'
        ),
      ),
    );
  }

  void deleteLaporan(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Laporan'),
        content: Text('Apakah Anda yakin ingin menghapus laporan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                laporanKerusakan.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Laporan berhasil dihapus')),
              );
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.red.shade50,
          child: Row(
            children: [
              Icon(Icons.report_problem, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Laporan kerusakan dari CSO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: laporanKerusakan.length,
            itemBuilder: (context, index) {
              final laporan = laporanKerusakan[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: laporan['ditindaklanjuti'] ? Colors.green : Colors.red,
                  ),
                  title: Text(laporan['deskripsi']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengirim: ${laporan['pengirim']}'),
                      Text('${laporan['tanggal']} - ${laporan['waktu']}'),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: laporan['ditindaklanjuti'] ? Colors.green.shade100 : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          laporan['ditindaklanjuti'] ? 'Ditindaklanjuti' : 'Belum Ditindaklanjuti',
                          style: TextStyle(
                            color: laporan['ditindaklanjuti'] ? Colors.green.shade800 : Colors.orange.shade800,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              laporan['ditindaklanjuti'] ? Icons.close : Icons.check,
                              color: laporan['ditindaklanjuti'] ? Colors.orange : Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(laporan['ditindaklanjuti'] ? 'Batalkan Tindak Lanjut' : 'Tandai Ditindaklanjuti'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'toggle') {
                        toggleTindakLanjut(index);
                      } else if (value == 'delete') {
                        deleteLaporan(index);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DashboardSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Ringkasan Statistik', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Checklist Hari Ini'),
            subtitle: Text('12 tugas selesai'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.build, color: Colors.orange),
            title: Text('Laporan Diselesaikan Minggu Ini'),
            subtitle: Text('5 laporan diselesaikan'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.percent, color: Colors.blue),
            title: Text('Progress Kebersihan'),
            subtitle: Text('Zona A: 75%, Zona B: 90%'),
          ),
        ),
      ],
    );
  }
}