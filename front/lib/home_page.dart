import 'package:flutter/material.dart';
import 'package:taller_1_diplomado/login_page.dart';
import 'package:taller_1_diplomado/signature_request_page.dart';
import 'package:taller_1_diplomado/upload_page.dart';
import 'package:taller_1_diplomado/user_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Variable para rastrear la página seleccionada

  // Lista de las páginas que se pueden mostrar
  final List<Widget> _pages = [
    const UploadPage(),
    const SignatureRequestPage(),
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Firmas digitales',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple[800],
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex], // Mostrar la página seleccionada
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[800],
            ),
            child: const Text(
              'MENU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.upload_file,
                  text: 'Upload Page',
                  index: 0, // Índice correspondiente a la página UploadPage
                ),
                _buildDrawerItem(
                  icon: Icons.request_page,
                  text: 'Signature Request Page',
                  index:
                      1, // Índice correspondiente a la página SignatureRequestPage
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  text: 'User Profile',
                  index:
                      2, // Índice correspondiente a la página UserProfilePage
                ),
                const Divider(),
                ListTile(
                  title: const Text('Cerrar sesión'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      onTap: () {
        setState(() {
          _selectedIndex = index; // Actualizar el índice seleccionado
        });
        Navigator.pop(context); // Cerrar el Drawer después de seleccionar
      },
    );
  }
}
