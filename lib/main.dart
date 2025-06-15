import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart';
import 'checklist_page.dart';
import 'jadwal_page.dart';
import 'placeholder_page.dart';
import 'package:image_picker/image_picker.dart';


void main() => runApp(CSOApp());

class CSOApp extends StatefulWidget {
  @override
  State<CSOApp> createState() => _CSOAppState();
}

class _CSOAppState extends State<CSOApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSO & Kebersihan',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Color(0xFFFFFCFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(toggleTheme: toggleTheme),
      routes: {
        '/dashboard': (context) => AdminDashboardPage(adminName: 'Admin'),
        '/laporan': (context) => PlaceholderPage(title: 'Laporan Kerusakan'),
        '/riwayat': (context) => PlaceholderPage(title: 'Riwayat Tugas & Laporan'),
        '/akun': (context) => PlaceholderPage(title: 'Manajemen Akun'),
      },
    );
  }
}


Map<String, String> akunTerdaftar = {
  'admin': '1234',
  'cso': '1234',
};

// ==================== LOGIN PAGE ====================
class LoginPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  LoginPage({required this.toggleTheme});

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
          MaterialPageRoute(builder: (_) => AdminDashboardPage(adminName: username)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainHomePage(user: username, toggleTheme: widget.toggleTheme)),
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
  final VoidCallback toggleTheme;
  MainHomePage({required this.user, required this.toggleTheme});

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
                MaterialPageRoute(builder: (_) => LoginPage(toggleTheme: widget.toggleTheme)),
                    (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  final List<Widget> _pages = [JadwalPage(), ChecklistPage(), LaporanPage()];
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
        ],
      ),
    );
  }
}

// ==================== LAPORAN ====================
class LaporanPage extends StatefulWidget {
  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  File? _imageFile;

  List<Map<String, dynamic>> laporanList = [];

  Future<void> pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void submitLaporan() {
    if (deskripsiController.text.isNotEmpty &&
        lokasiController.text.isNotEmpty &&
        _imageFile != null) {
      setState(() {
        laporanList.add({
          'lokasi': lokasiController.text,
          'deskripsi': deskripsiController.text,
          'foto': _imageFile,
          'status': 'Menunggu',
        });
        deskripsiController.clear();
        lokasiController.clear();
        _imageFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Harap lengkapi semua data dan upload foto.")));
    }
  }

  void deleteLaporan(int index) {
    setState(() {
      laporanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Kerusakan"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: lokasiController,
                  decoration: InputDecoration(
                    labelText: 'Lokasi Kejadian',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Kerusakan',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: Icon(Icons.photo),
                      label: Text('Upload Foto'),
                    ),
                    SizedBox(width: 10),
                    _imageFile != null
                        ? Text("✓ Foto terpilih", style: TextStyle(color: Colors.green))
                        : Text("Belum ada foto")
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: submitLaporan,
                  child: Text('Kirim Laporan'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 48)),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                final laporan = laporanList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: laporan['foto'] != null
                        ? Image.file(
                      laporan['foto'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image_not_supported),
                    title: Text(laporan['lokasi']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(laporan['deskripsi']),
                        Text("Status: ${laporan['status']}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteLaporan(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}