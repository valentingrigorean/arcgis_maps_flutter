import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class CredentialPage extends StatefulWidget {
  const CredentialPage({super.key});

  @override
  State<CredentialPage> createState() => _CredentialPageState();
}

class _CredentialPageState extends State<CredentialPage> {
  bool _didCreateCredential = false;
  String? _tokenHandlerId;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credential'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_tokenHandlerId != null) {
                    await ArcGISCredentialStore()
                        .removeCredential(_tokenHandlerId!);
                    _tokenHandlerId = null;
                    _didCreateCredential = false;
                  } else {
                    _tokenHandlerId =
                        await ArcGISCredentialStore().addCredential(
                      url: 'https://www.arcgis.com',
                      username: 'nla_admin',
                      password: 'ikkeWindows7',
                    );
                    _didCreateCredential = true;
                  }
                } catch (e) {
                  _error = e.toString();
                  _didCreateCredential = false;
                }
                setState(() {});
              },
              child: Text(
                _didCreateCredential
                    ? 'Remove Credentials'
                    : 'Create Credential',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
