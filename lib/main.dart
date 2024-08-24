import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Taller 1',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Diplomado GITI Módulo 3'),
    );
  }
}

final _formKeyName = GlobalKey<FormState>();
late TextEditingController _nameController;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>? _keyPair;

  Future<void> _generateKeys() async {
    var keyHelper = RsaKeyHelper();
    var keyPair =
        await keyHelper.computeRSAKeyPair(keyHelper.getSecureRandom());
    setState(() {
      _keyPair = keyPair;
    });
  }

  void _downloadPrivateKey(String privateKey, String fileName) {
    final bytes = utf8.encode(privateKey);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.txt")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
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
                                _generateKeys().then((_) {
                                  final name = _nameController.text;
                                  print('Nombre: $name');
                                  print(
                                      'Clave Pública: ${_keyPair!.publicKey}');
                                  print(
                                      'Clave Privada: ${_keyPair!.privateKey}');
                                });
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
                              'Generar Llaves',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (_keyPair != null) ...[
                          Text('Clave Pública: ${_keyPair!.publicKey}'),
                          ElevatedButton(
                            onPressed: () {
                              String keyBase64Encrypted = RsaKeyHelper()
                                  .encodePrivateKeyToPemPKCS1(
                                      _keyPair!.privateKey as RSAPrivateKey);
                              _downloadPrivateKey(
                                  keyBase64Encrypted, 'private_key');
                            },
                            child: const Text('Descargar Clave Privada'),
                          ),
                        ],
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
