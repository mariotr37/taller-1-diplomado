import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // Lista de archivos y su estado de carga
  final List<Map<String, dynamic>> files = [
    {"name": "style-guide.pdf", "completed": true, "progress": 100.0},
    {"name": "branding-info.doc", "completed": false, "progress": 66.66},
    {"name": "branding-info.doc", "completed": false, "progress": 26.66},
    {"name": "branding-info.doc", "completed": false, "progress": 76.66},
    {"name": "branding-info.doc", "completed": false, "progress": 16.66},
    {"name": "branding-info.doc", "completed": false, "progress": 6},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800]!,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: const EdgeInsets.all(26.0),
            margin: const EdgeInsets.all(46.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Firmar archivos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                ),
                const SizedBox(height: 20),
                _buildFileList(),
                const SizedBox(height: 20),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple[800]!, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: Colors.purple[800]!,
                        ),
                        InkWell(
                          onTap: () {
                            // Implementar función de navegación
                          },
                          child: Text(
                            'Cargar archivos',
                            style: TextStyle(
                              color: Colors.purple[800]!,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Lista de usuarios con checkboxes
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar usuarios para firmar:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildUserCheckboxes(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implementar función de enviar
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[800]!,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Solicitar firma',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      shrinkWrap:
          true, // Permite que ListView se ajuste a la altura de los ítems
      physics:
          const NeverScrollableScrollPhysics(), // Deshabilita el scroll independiente
      itemCount: files.length,
      itemBuilder: (context, index) {
        return _buildFileItem(
          files[index]['name'],
          files[index]['completed'],
          progress: files[index]['progress'],
        );
      },
    );
  }

  Widget _buildFileItem(String fileName, bool completed,
      {double progress = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.insert_drive_file,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (!completed)
            Expanded(
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey[300],
                color: Colors.yellow[700],
              ),
            ),
          if (completed)
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildUserCheckboxes() {
    final List<Map<String, dynamic>> users = [
      {"name": "SEBASTIAN", "isChecked": false},
      {"name": "JESSICA", "isChecked": false},
      {"name": "USER 1", "isChecked": false},
      {"name": "USER 2", "isChecked": false},
      {"name": "USER 3", "isChecked": false},
    ];

    return SizedBox(
      height: 150, // Limita la altura del ListView
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(users[index]['name']),
            value: users[index]['isChecked'],
            onChanged: (newValue) {
              setState(() {
                users[index]['isChecked'] = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }
}
