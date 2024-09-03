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
            borderRadius: BorderRadius.circular(10),
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
              _buildRequestTable(),
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
                      borderRadius: BorderRadius.circular(5),
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

  Widget _buildRequestTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.1),
        1: FlexColumnWidth(0.4),
        2: FlexColumnWidth(0.4),
        3: FlexColumnWidth(0.1),
      },
      border: TableBorder.all(
        color: Colors.purple[800]!,
        width: 1.5,
        borderRadius: BorderRadius.circular(5),
      ),
      children: [
        const TableRow(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 246, 212, 255),
          ),
          children: [
            SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Nombre de usuario',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Nombre archivo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
            decoration: BoxDecoration(
              color: index.isEven ? Colors.white : Colors.purple[50],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Radio<int>(
                  value: index,
                  groupValue: _selectedRequestIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedRequestIndex = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  request['userName'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  request['fileName'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.purple),
                onPressed: () {
                  if (_selectedRequestIndex == null) {
                    _showSelectionDialog();
                  } else {
                    _downloadFile(request['fileUrl'], request['fileName']);
                  }
                },
              ),
            ],
          );
        }),
      ],
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
        XFile? localSelectedFile;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Subir archivo para autenticar la firma'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      const typeGroup = XTypeGroup(
                        label: 'files',
                      );
                      final XFile? file =
                          await openFile(acceptedTypeGroups: [typeGroup]);

                      if (file != null) {
                        setState(() {
                          localSelectedFile = file;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Archivo seleccionado: ${file.name}'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Bordes rectos
                      ),
                    ),
                    child: const Text('Seleccionar archivo'),
                  ),
                  const SizedBox(height: 10),
                  if (localSelectedFile != null)
                    Text(
                      'Archivo seleccionado: ${localSelectedFile!.name}',
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
                  onPressed: localSelectedFile != null
                      ? () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Éxito'),
                                content:
                                    const Text('Archivo firmado con éxito.'),
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
                      : null, // Deshabilitar si no hay archivo seleccionado
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Bordes rectos
                    ),
                  ),
                  child: const Text('Subir y firmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
