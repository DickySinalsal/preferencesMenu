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
      title: 'Preferences & Menu Demo',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
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
  String _userName = 'User';
  bool _notificationsEnabled = true;
  double _fontSize = 16.0;
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    });
  }

  void _saveUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('isDarkMode', widget.isDarkMode);
    await prefs.setString('language', widget.selectedLanguage);
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
        backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                      SizedBox(width: 8),
                      Text('Profile'),
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
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.red)),
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
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Favorites';
      case 2:
        return 'Profile';
      default:
        return 'App';
    }
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildFavoritesPage();
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
            accountEmail: Text('${_userName.toLowerCase()}@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context);
              _showHelpDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
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
          Text(
            'Welcome, $_userName!',
            style: TextStyle(fontSize: _fontSize + 8, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          
          // Quick Settings Card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Settings',
                    style: TextStyle(fontSize: _fontSize + 2, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    title: Text('Dark Mode', style: TextStyle(fontSize: _fontSize)),
                    subtitle: Text('Toggle dark/light theme', style: TextStyle(fontSize: _fontSize - 2)),
                    value: widget.isDarkMode,
                    onChanged: (value) {
                      widget.onThemeChanged(value);
                      _saveUserPreferences();
                    },
                  ),
                  SwitchListTile(
                    title: Text('Notifications', style: TextStyle(fontSize: _fontSize)),
                    subtitle: Text('Enable/disable notifications', style: TextStyle(fontSize: _fontSize - 2)),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveUserPreferences();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Menu Grid
          Text(
            'Features',
            style: TextStyle(fontSize: _fontSize + 2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildFeatureCard('Settings', Icons.settings, () => _showSettingsDialog()),
              _buildFeatureCard('Profile', Icons.person, () => _onItemTapped(2)),
              _buildFeatureCard('Help', Icons.help, () => _showHelpDialog()),
              _buildFeatureCard('About', Icons.info, () => _showAboutDialog()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesPage() {
    List<String> favorites = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.favorite, color: Colors.white),
            ),
            title: Text(favorites[index], style: TextStyle(fontSize: _fontSize)),
            subtitle: Text('Favorite item ${index + 1}', style: TextStyle(fontSize: _fontSize - 2)),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(favorites[index]);
              },
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
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
              style: TextStyle(fontSize: 36, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _userName,
            style: TextStyle(fontSize: _fontSize + 4, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_userName.toLowerCase()}@example.com',
            style: TextStyle(fontSize: _fontSize, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Profile', style: TextStyle(fontSize: _fontSize)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _showEditProfileDialog,
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings', style: TextStyle(fontSize: _fontSize)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: _showSettingsDialog,
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Privacy', style: TextStyle(fontSize: _fontSize)),
                  trailing: Icon(Icons.arrow_forward_ios),
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

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        _onItemTapped(2);
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
              title: Text('Settings'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      value: widget.isDarkMode,
                      onChanged: (value) {
                        widget.onThemeChanged(value);
                        setDialogState(() {});
                        _saveUserPreferences();
                      },
                    ),
                    SwitchListTile(
                      title: Text('Notifications'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        setDialogState(() {});
                        _saveUserPreferences();
                      },
                    ),
                    ListTile(
                      title: Text('Language'),
                      subtitle: Text(widget.selectedLanguage),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        _showLanguageDialog();
                      },
                    ),
                    ListTile(
                      title: Text('Font Size'),
                      subtitle: Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 6,
                        label: _fontSize.round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _fontSize = value;
                          });
                          setDialogState(() {});
                          _saveUserPreferences();
                        },
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
    List<String> languages = ['Indonesia', 'English', 'Español', 'Français'];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: widget.selectedLanguage,
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
          title: Text('Edit Profile'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = nameController.text.isNotEmpty ? nameController.text : 'User';
                });
                _saveUserPreferences();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Preferences & Menu Demo',
      applicationVersion: _appVersion,
      applicationIcon: FlutterLogo(size: 50),
      children: [
        Text('This is a demo app showing preferences and menu implementation in Flutter.'),
        SizedBox(height: 10),
        Text('Features:'),
        Text('• SharedPreferences for data persistence'),
        Text('• Dynamic theme switching'),
        Text('• Multi-language support'),
        Text('• Customizable settings'),
        Text('• Navigation drawer & bottom bar'),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to use this app:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Use bottom navigation to switch between pages'),
              Text('• Access drawer menu by swiping from left'),
              Text('• Tap app bar menu (⋮) for quick actions'),
              Text('• Customize settings in Settings dialog'),
              Text('• Edit your profile in Profile page'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(String item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete "$item"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$item deleted')),
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
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully')),
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