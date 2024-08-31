import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:file_selector/file_selector.dart';

class SignatureRequestPage extends StatefulWidget {
  const SignatureRequestPage({super.key});

  @override
  _SignatureRequestPageState createState() => _SignatureRequestPageState();
}

class _SignatureRequestPageState extends State<SignatureRequestPage> {
  // Lista de solicitudes
  final List<Map<String, dynamic>> requests = [
    {
      "userName": "JESSICA JOHANA",
      "fileName": "COPIA.PDF",
      "fileUrl": "https://www.example.com/copia.pdf"
    },
    {
      "userName": "MARIO",
      "fileName": "HOJA DE VIDA.DOCX",
      "fileUrl": "https://www.example.com/hoja_de_vida.docx"
    },
  ];

  // Variable para rastrear la selección de radio buttons
  int? _selectedRequestIndex;
  String? _selectedFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.65,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solicitud de firmas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: const {
                  0: FlexColumnWidth(0.2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(0.2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: const [
                      SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nombre de usuario',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nombre archivo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox.shrink(),
                    ],
                  ),
                  ...requests.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> request = entry.value;
                    return TableRow(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: _selectedRequestIndex,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRequestIndex = value;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(request['userName']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(request['fileName']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () {
                            if (_selectedRequestIndex == null) {
                              _showSelectionDialog();
                            } else {
                              _downloadFile(
                                  request['fileUrl'], request['fileName']);
                            }
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _selectedRequestIndex != null
                      ? () {
                          _showUploadDialog();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[800],
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Firmar archivo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para descargar el archivo
  void _downloadFile(String fileUrl, String fileName) async {
    await FileDownloader.downloadFile(
      url: fileUrl,
      name: fileName,
      onDownloadCompleted: (path) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Descarga completa: $fileName')),
        );
      },
      onDownloadError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar: $fileName')),
        );
      },
    );
  }

  // Mostrar un diálogo si no se seleccionó ningún archivo
  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar archivo'),
          content: const Text(
              'Por favor, seleccione un archivo antes de continuar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar el diálogo para subir un archivo
  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Subir lleva para autenticar la firma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final XFile? file = await openFile();

                  if (file != null) {
                    setState(() {
                      _selectedFilePath = file.path;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Archivo seleccionado: ${file.name}'),
                      ),
                    );
                  }
                },
                child: const Text('Seleccionar archivo'),
              ),
              const SizedBox(height: 10),
              if (_selectedFilePath != null)
                Text(
                  'Archivo seleccionado: $_selectedFilePath',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _selectedFilePath != null
                  ? () {
                      // Aquí puedes implementar la lógica para firmar el archivo
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Archivo firmado con éxito.'),
                        ),
                      );
                    }
                  : null, // Deshabilitar si no hay archivo seleccionado
              child: const Text('Subir y firmar'),
            ),
          ],
        );
      },
    );
  }
}
