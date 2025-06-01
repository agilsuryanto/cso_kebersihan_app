import 'dart:async';
import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart';

void main() => runApp(CSOApp());

class CSOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSO & Kebersihan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Color(0xFFFFFCFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

Map<String, String> akunTerdaftar = {
  'admin': '1234',
  'cso': '1234',
};

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int _loginAttempts = 0;
  bool _isBlocked = false;
  Timer? _blockTimer;

  void _login(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if (_isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login diblokir sementara. Coba lagi nanti.')),
      );
      return;
    }

    if (akunTerdaftar.containsKey(username) &&
        akunTerdaftar[username] == password) {
      setState(() {
        _loginAttempts = 0;
        _isBlocked = false;
      });

      if (username == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainHomePage(user: username)),
        );
      }
    } else {
      setState(() {
        _loginAttempts++;
      });

      if (_loginAttempts >= 3) {
        setState(() {
          _isBlocked = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terlalu banyak percobaan. Tunggu 10 detik.')),
        );

        _blockTimer = Timer(Duration(seconds: 10), () {
          setState(() {
            _isBlocked = false;
            _loginAttempts = 0;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal ($_loginAttempts/3)')),
        );
      }
    }
  }

  @override
  void dispose() {
    _blockTimer?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 120),
                SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isBlocked ? null : () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isBlocked ? Colors.grey : Colors.green,
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: _goToRegister,
                  child: Text('Belum punya akun? Daftar di sini'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== ADMIN DASHBOARD PAGE ====================
class AdminDashboardPage extends StatelessWidget {
  final List<String> checklistTugas = [
    'Menyapu lantai kelas',
    'Mengepel lantai kantor',
    'Membersihkan meja guru'
  ];

  final List<String> laporanKerusakan = [
    'Kipas angin rusak di kelas 7A',
    'Kaca pecah di lantai 2',
    'Sampah menumpuk di taman belakang'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin - Hasil Input User')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Checklist Tugas Harian',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...checklistTugas.map((tugas) => Card(
            child: ListTile(
              leading: Icon(Icons.check_box, color: Colors.green),
              title: Text(tugas),
            ),
          )),
          SizedBox(height: 30),
          Text('Laporan Kerusakan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...laporanKerusakan.map((laporan) => Card(
            child: ListTile(
              leading: Icon(Icons.report_problem, color: Colors.red),
              title: Text(laporan),
            ),
          )),
        ],
      ),
    );
  }
}

// ==================== REGISTER PAGE ====================
class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register(BuildContext context) {
    final username = usernameController.text;
    final password = passwordController.text;

    if (akunTerdaftar.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username sudah terdaftar')),
      );
    } else if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username dan Password tidak boleh kosong')),
      );
    } else {
      akunTerdaftar[username] = password;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.pop(context); // Kembali ke halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrasi')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username Baru',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _register(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}


// ==================== MAIN HOMEPAGE ====================
class MainHomePage extends StatefulWidget {
  final String user;
  MainHomePage({required this.user});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
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
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  final List<Widget> _pages = [JadwalPage(), ChecklistPage(), LaporanPage(),  ];
  final List<String> _titles = [
    'Jadwal Harian',
    'Checklist Tugas',
    'Laporan Kerusakan'
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
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          )
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Jadwal'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box), label: 'Checklist'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

// ==================== JADWAL ====================
class JadwalPage extends StatelessWidget {
  final Map<String, List<String>> jadwal = {
    'Area Kelas': [
      'Menyapu lantai',
      'Mengepel lantai',
      'Membersihkan dan Mengeelap Meja + Kursi',
      'Membersikan Langit langit',
      'Mengelap Kaca dan Dinding'
    ],
    'Gedung Bagian Dalam': [
      'Membersihkan Tralis, Dinding dan Lantai',
      'Menyapu lantai',
      'Mengepel lantai',
      'Membersikan Tangga',
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
            title: Text(entry.key,
                style: TextStyle(fontWeight: FontWeight.bold)),
            children:
            entry.value.map((task) => ListTile(title: Text(task))).toList(),
          ),
        );
      }).toList(),
    );
  }
}

// ==================== CHECKLIST ====================
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
      'Membersikan Tangga': false,
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

// ==================== LAPORAN ====================
class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}
class _LaporanPageState extends State<LaporanPage> {
  final TextEditingController laporanController = TextEditingController();
  List<Map<String, dynamic>> laporanList = [];

  void submitLaporan() {
    if (laporanController.text.isNotEmpty) {
      setState(() {
        laporanList.add({
          'deskripsi': laporanController.text,
          'ditindaklanjuti': false,
        });
        laporanController.clear();
      });
    }
  }

  void editLaporan(int index) {
    laporanController.text = laporanList[index]['deskripsi'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Laporan'),
        content: TextField(controller: laporanController),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal')),
          TextButton(
              onPressed: () {
                setState(() {
                  laporanList[index]['deskripsi'] = laporanController.text;
                });
                laporanController.clear();
                Navigator.pop(context);
              },
              child: Text('Simpan')),
        ],
      ),
    );
  }

  void deleteLaporan(int index) {
    setState(() {
      laporanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: laporanController,
            decoration: InputDecoration(
              labelText: 'Deskripsi Kerusakan',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: submitLaporan,
          child: Text('Kirim Laporan'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 48)),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: laporanList.length,
            itemBuilder: (context, index) {
              final laporan = laporanList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text(laporan['deskripsi']),
                  subtitle: Text(laporan['ditindaklanjuti']
                      ? 'Status: Ditindaklanjuti'
                      : 'Status: Belum Ditindaklanjuti'),
                  trailing: laporan['ditindaklanjuti']
                      ? null
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => editLaporan(index)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteLaporan(index)),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
