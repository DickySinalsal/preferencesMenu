import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Indonesia';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Indonesia';
    });
  }

  void _updateTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _updateLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K-Drama Fan App',
      theme: _isDarkMode ? 
        ThemeData.dark().copyWith(
          primaryColor: const Color.fromARGB(255, 10, 14, 218),
          colorScheme: ColorScheme.dark(primary: const Color.fromARGB(255, 8, 53, 250)),
        ) : 
        ThemeData.light().copyWith(
          primaryColor: const Color.fromARGB(255, 37, 22, 241),
          colorScheme: ColorScheme.light(primary: const Color.fromARGB(255, 12, 56, 250)),
        ),
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        selectedLanguage: _selectedLanguage,
        onThemeChanged: _updateTheme,
        onLanguageChanged: _updateLanguage,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final String selectedLanguage;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  HomeScreen({
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = 'K-Drama Fan';
  bool _notificationsEnabled = true;
  double _fontSize = 16.0;
  String _appVersion = '1.0.0';
  String _selectedAvatar = 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face';

  // Data K-Drama dan aktris
  final List<Map<String, String>> kActresses = [
    {
      'name': 'go youn-jung',
      'drama': 'Resident Playbook',
      'image': 'https://imgs.search.brave.com/0WpCQpMp5WwkYESJBdckrftkzcV-Jh1ABfYY73ylqUM/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMuZ3FpbmRpYS5j/b20vcGhvdG9zLzY4/MmFjODU2Y2E4NjZk/NmMzNWI2OGNjMS8x/OjEvd183NzUsY19s/aW1pdC9SZXNpZGVu/dC1QbGF5Ym9vay1l/bmRpbmctZXhwbGFp/bmVyLmpwZw'
    },
    {
      'name': 'Shin eun-soo',
      'drama': 'Twinkling Watermelon',
      'image': 'https://imgs.search.brave.com/KpPHleFJQD3FhIKF1KuLE_LB7dJslTBTI-0PFgaPtPw/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzhjL2Ex/L2UzLzhjYTFlMzFi/OGRiMWQ5MjBmYzJj/OTY2Nzc0YmUzYThh/LmpwZw'
    },
    {
      'name': 'Park Shin-hye',
      'drama': 'The Heirs',
      'image': 'https://images.unsplash.com/photo-1534751516642-a1af1ef26a56?w=150&h=150&fit=crop&crop=face'
    },
    {
      'name': 'IU (Lee Ji-eun)',
      'drama': 'Hotel Del Luna',
      'image': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150&h=150&fit=crop&crop=face'
    },
    {
      'name': 'Kim So-hyun',
      'drama': 'Love Alarm',
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face'
    },
  ];

  final List<Map<String, String>> kDramas = [
    {
      'title': 'Moving',
      'genre': 'Act',
      'rating': '9.0',
      'image': 'https://imgs.search.brave.com/A6Upg5FRr4TjWasacWN_KSDxx0AITdrteSmTRcsvwnY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvZW4vZi9mMi9N/b3ZpbmdfJTI4U291/dGhfS29yZWFuX1RW/X3NlcmllcyUyOS5w/bmc'
    },
    {
      'title': 'Twinkling Watermelon',
      'genre': 'Romance',
      'rating': '8.8',
      'image': 'https://imgs.search.brave.com/vFo1o9SHLxQz5SC9YZR3dLziTkAVwTCHreWaZtQ0f5A/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJhY2Nlc3Mu/Y29tL2Z1bGwvMTEx/OTQ5MTYuanBn'
    },
    {
      'title': 'Deaths Game',
      'genre': 'Horror',
      'rating': '8.3',
      'image': 'https://imgs.search.brave.com/JI5BDCIfOrX41HkAhyjp5KmhdUHC0AEkGJaRLS8O_vY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL00v/TVY1Qk56VTFPVGMx/WXpRdE1qQXhPUzAw/TmpoaExUazJabVF0/TTJNMllUVTROVFps/WWpNNFhrRXlYa0Zx/Y0djQC5qcGc'
    },
    {
      'title': 'Vincenzo',
      'genre': 'Action',
      'rating': '8.4',
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=300&fit=crop'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'K-Drama Fan';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
      _selectedAvatar = prefs.getString('avatar') ?? 'https://imgs.search.brave.com/kOqjnXzYyuEHOKM8f5EQwybSOTZVSZ-f0JdCxL48mSQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi9jL2NmL1Jl/eF9PcmFuZ2VfQ291/bnR5Xy1fUGhvdG9f/YnlfU2t5bGVyX1By/YWRoYW5fJTI4Y3Jv/cHBlZCUyOS5qcGcv/NTEycHgtUmV4X09y/YW5nZV9Db3VudHlf/LV9QaG90b19ieV9T/a3lsZXJfUHJhZGhh/bl8lMjhjcm9wcGVk/JTI5LmpwZw';
    });
  }

  void _saveUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('isDarkMode', widget.isDarkMode);
    await prefs.setString('language', widget.selectedLanguage);
    await prefs.setString('avatar', _selectedAvatar);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: const Color.fromARGB(255, 11, 7, 240),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 17, 33, 250), Colors.purple[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: const Color.fromARGB(255, 26, 9, 255)),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'actresses',
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('K-Actresses'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
                      SizedBox(width: 8),
                      Text('Settings'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'about',
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Theme.of(context).iconTheme.color),
                      SizedBox(width: 8),
                      Text('About'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: const Color.fromARGB(255, 4, 194, 252)),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: const Color.fromARGB(255, 4, 196, 252))),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'K-Dramas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 18, 51, 241),
        onTap: _onItemTapped,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'K-Drama Hub';
      case 1:
        return 'My K-Dramas';
      case 2:
        return 'Profile';
      default:
        return 'K-Drama Fan App';
    }
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildKDramasPage();
      case 2:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_userName),
            accountEmail: Text('${_userName.toLowerCase().replaceAll(' ', '')}@kdrama.fan'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_selectedAvatar),
              backgroundColor: Colors.pink[100],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[400]!, Colors.purple[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.pink),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.tv, color: Colors.purple),
            title: Text('K-Dramas'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.amber),
            title: Text('K-Actresses'),
            onTap: () {
              Navigator.pop(context);
              _showKActressesDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[600]),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help, color: Colors.blue),
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context);
              _showHelpDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.green),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card with gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[300]!, Colors.purple[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(_selectedAvatar),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Annyeong, $_userName! 👋',
                            style: TextStyle(
                              fontSize: _fontSize + 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Ready for some K-Drama magic?',
                            style: TextStyle(
                              fontSize: _fontSize,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 25),
          
          // Quick Actions
          Text(
            '✨ Quick Actions',
            style: TextStyle(fontSize: _fontSize + 2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard('K-Actresses', Icons.star, Colors.amber, () => _showKActressesDialog()),
              _buildActionCard('My Dramas', Icons.tv, Colors.purple, () => _onItemTapped(1)),
              _buildActionCard('Settings', Icons.settings, Colors.blue, () => _showSettingsDialog()),
              _buildActionCard('Profile', Icons.person, Colors.pink, () => _onItemTapped(2)),
            ],
          ),

          SizedBox(height: 25),

          // Featured K-Dramas Preview
          Text(
            '🎬 Trending K-Dramas',
            style: TextStyle(fontSize: _fontSize + 2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Container(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kDramas.length,
              itemBuilder: (context, index) {
                final drama = kDramas[index];
                return Container(
                  width: 120,
                  margin: EdgeInsets.only(right: 12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              drama['image']!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.tv, size: 40, color: Colors.grey[600]),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drama['title']!,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 12, color: Colors.amber),
                                  SizedBox(width: 2),
                                  Text(drama['rating']!, style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: _fontSize - 1, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKDramasPage() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: kDramas.length,
      itemBuilder: (context, index) {
        final drama = kDramas[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 120,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.network(
                    drama['image']!,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        color: Colors.grey[300],
                        child: Icon(Icons.tv, size: 30, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drama['title']!,
                              style: TextStyle(
                                fontSize: _fontSize + 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                drama['genre']!,
                                style: TextStyle(
                                  fontSize: _fontSize - 2,
                                  color: Colors.pink[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  drama['rating']!,
                                  style: TextStyle(fontSize: _fontSize - 1),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.favorite, color: Colors.red, size: 20),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Added ${drama['title']} to favorites!')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.play_circle_filled, color: Colors.pink, size: 20),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Playing ${drama['title']}...')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[300]!, Colors.purple[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_selectedAvatar),
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showAvatarSelection,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.camera_alt, size: 20, color: Colors.pink),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  _userName,
                  style: TextStyle(
                    fontSize: _fontSize + 4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_userName.toLowerCase().replaceAll(' ', '')}@kdrama.fan',
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Profile Options
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.edit, color: Colors.blue),
                  ),
                  title: Text('Edit Profile', style: TextStyle(fontSize: _fontSize)),
                  subtitle: Text('Change name and avatar', style: TextStyle(fontSize: _fontSize - 2)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showEditProfileDialog,
                ),
                Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.settings, color: Colors.green),
                  ),
                  title: Text('Settings', style: TextStyle(fontSize: _fontSize)),
                  subtitle: Text('App preferences', style: TextStyle(fontSize: _fontSize - 2)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showSettingsDialog,
                ),
                Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.star, color: Colors.amber),
                  ),
                  title: Text('Favorite Actresses', style: TextStyle(fontSize: _fontSize)),
                  subtitle: Text('View K-actress collection', style: TextStyle(fontSize: _fontSize - 2)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showKActressesDialog,
                ),
                Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.privacy_tip, color: Colors.orange),
                  ),
                  title: Text('Privacy', style: TextStyle(fontSize: _fontSize)),
                  subtitle: Text('Privacy settings', style: TextStyle(fontSize: _fontSize - 2)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Privacy settings opened')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Avatar'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: kActresses.length,
              itemBuilder: (context, index) {
                final actress = kActresses[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = actress['image']!;
                    });
                    _saveUserPreferences();
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(actress['image']!),
                        backgroundColor: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Text(
                        actress['name']!.split(' ')[0],
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showKActressesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 8),
              Text('K-Actresses'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: kActresses.length,
              itemBuilder: (context, index) {
                final actress = kActresses[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(actress['image']!),
                      backgroundColor: Colors.grey[300],
                    ),
                    title: Text(
                      actress['name']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Famous for: ${actress['drama']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('❤️ Added ${actress['name']} to favorites!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info, color: Colors.blue, size: 20),
                          onPressed: () {
                            _showActressInfo(actress);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showActressInfo(Map<String, String> actress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(actress['image']!),
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 16),
              Text(
                actress['name']!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  actress['drama']!,
                  style: TextStyle(
                    color: Colors.pink[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(height: 4),
                      Text('9.2', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rating', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.tv, color: Colors.purple, size: 24),
                      SizedBox(height: 4),
                      Text('15+', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Dramas', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 24),
                      SizedBox(height: 4),
                      Text('2.1M', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Fans', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Following ${actress['name']}! 💕')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: Text('Follow', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        _onItemTapped(2);
        break;
      case 'actresses':
        _showKActressesDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
      case 'about':
        _showAboutDialog();
        break;
      case 'logout':
        _showLogoutDialog();
        break;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.settings, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: Colors.pink[50],
                      child: SwitchListTile(
                        title: Text('🌙 Dark Mode'),
                        subtitle: Text('Toggle dark/light theme'),
                        value: widget.isDarkMode,
                        activeColor: Colors.pink,
                        onChanged: (value) {
                          widget.onThemeChanged(value);
                          setDialogState(() {});
                          _saveUserPreferences();
                        },
                      ),
                    ),
                    Card(
                      color: Colors.blue[50],
                      child: SwitchListTile(
                        title: Text('🔔 Notifications'),
                        subtitle: Text('K-Drama updates & news'),
                        value: _notificationsEnabled,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                          setDialogState(() {});
                          _saveUserPreferences();
                        },
                      ),
                    ),
                    Card(
                      color: Colors.green[50],
                      child: ListTile(
                        leading: Icon(Icons.language, color: Colors.green),
                        title: Text('🌐 Language'),
                        subtitle: Text(widget.selectedLanguage),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pop(context);
                          _showLanguageDialog();
                        },
                      ),
                    ),
                    Card(
                      color: Colors.orange[50],
                      child: ListTile(
                        leading: Icon(Icons.text_fields, color: Colors.orange),
                        title: Text('📝 Font Size'),
                        subtitle: Slider(
                          value: _fontSize,
                          min: 12.0,
                          max: 24.0,
                          divisions: 6,
                          label: _fontSize.round().toString(),
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            setState(() {
                              _fontSize = value;
                            });
                            setDialogState(() {});
                            _saveUserPreferences();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLanguageDialog() {
    List<Map<String, String>> languages = [
      {'code': 'Indonesia', 'name': '🇮🇩 Bahasa Indonesia'},
      {'code': 'English', 'name': '🇺🇸 English'},
      {'code': 'Korean', 'name': '🇰🇷 한국어'},
      {'code': 'Japanese', 'name': '🇯🇵 日本語'},
    ];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language['name']!),
                value: language['code']!,
                groupValue: widget.selectedLanguage,
                activeColor: Colors.pink,
                onChanged: (value) {
                  widget.onLanguageChanged(value!);
                  _saveUserPreferences();
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    TextEditingController nameController = TextEditingController(text: _userName);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Edit Profile'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_selectedAvatar),
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showAvatarSelection,
                icon: Icon(Icons.camera_alt),
                label: Text('Change Avatar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  foregroundColor: Colors.pink[800],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = nameController.text.isNotEmpty ? nameController.text : 'K-Drama Fan';
                });
                _saveUserPreferences();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'K-Drama Fan App',
      applicationVersion: _appVersion,
      applicationIcon: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.purple],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.tv, size: 30, color: Colors.white),
      ),
      children: [
        SizedBox(height: 10),
        Text('🎬 Your ultimate K-Drama companion app!'),
        SizedBox(height: 10),
        Text('✨ Features:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('• 📱 Beautiful K-Drama themed interface'),
        Text('• 🌟 K-Actress gallery with favorites'),
        Text('• 🎭 Drama collection and ratings'),
        Text('• 🎨 Customizable themes and avatars'),
        Text('• 🔔 Smart notifications'),
        Text('• 🌍 Multi-language support'),
        SizedBox(height: 10),
        Text('Made with ❤️ for K-Drama fans worldwide!'),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.help, color: Colors.blue),
              SizedBox(width: 8),
              Text('Help & Tips'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎯 How to use this app:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildHelpItem('🏠', 'Home tab shows trending K-Dramas and quick actions'),
                _buildHelpItem('📺', 'K-Dramas tab displays your drama collection'),
                _buildHelpItem('👤', 'Profile tab for personal settings and info'),
                _buildHelpItem('🌟', 'Tap actress cards to view details and follow'),
                _buildHelpItem('❤️', 'Add dramas to favorites with the heart icon'),
                _buildHelpItem('🎨', 'Change avatar by tapping camera icon in profile'),
                _buildHelpItem('⚙️', 'Customize app settings in Settings dialog'),
                _buildHelpItem('🌙', 'Toggle dark mode for better night viewing'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Got it! 👍'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: _fontSize - 1)),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmation(String item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Item'),
            ],
          ),
          content: Text('Are you sure you want to remove "$item" from your favorites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('💔 $item removed from favorites'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sentiment_dissatisfied, size: 50, color: Colors.grey),
              SizedBox(height: 16),
              Text('Are you sure you want to logout?'),
              Text('We\'ll miss you! 🥺', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Stay'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('👋 Logged out successfully! See you soon!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}