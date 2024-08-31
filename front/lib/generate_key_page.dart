import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

final _formKeyName = GlobalKey<FormState>();
late TextEditingController _nameController;

class GenerateKeyPage extends StatefulWidget {
  const GenerateKeyPage({super.key});

  @override
  State<GenerateKeyPage> createState() => _GenerateKeyPageState();
}

class _GenerateKeyPageState extends State<GenerateKeyPage> {
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _sendData() async {
    final name = _nameController.text;
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/guardar_usuario'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        final privateKey = responseData['privateKey'];
        final message = responseData['message'];

        _showAlert(context, 'Éxito', message);
        _downloadPrivateKey(privateKey, 'private_key');
      } else {
        _showAlert(context, 'Error', 'Error al guardar el usuario');
      }
    } catch (e) {
      _showAlert(context, 'Error', 'Error: $e');
    }
  }

  void _showAlert(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
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

  void _downloadPrivateKey(String privateKey, String fileName) {
    final bytes = utf8.encode(privateKey);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.pem")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        title: const Center(
          child: Text(
            'Diplomado GITI Módulo 3',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 400,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16)),
                      color: Colors.deepPurple[800],
                    ),
                    child: const Center(
                      child: Text(
                        'TALLER 1\n\nHecho por:\n\n- Yesica Johana Ospina Patiño\n- Juan Jose Hincapie Ortiz\n- Juan Sebastian Rodriguez Palacio\n- Mario Alejandro Tabares Ramírez',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    height: 400,
                    width: 350,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Nombre',
                            style: TextStyle(
                                color: Colors.deepPurple[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: _formKeyName,
                                child: SizedBox(
                                  height: 60,
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                      hintText: 'Ingresa tu nombre',
                                      contentPadding:
                                          const EdgeInsets.only(left: 20),
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 1),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, ingrese su nombre';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKeyName.currentState!.validate()) {
                                _sendData();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurple.shade800),
                              padding: MaterialStateProperty.resolveWith(
                                  (states) => const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 30)),
                            ),
                            child: const Text(
                              'Guardar Usuario',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
