import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/material.dart';

class AuthenticateWithOAuthScreen extends StatefulWidget {
  const AuthenticateWithOAuthScreen({super.key});

  @override
  State<AuthenticateWithOAuthScreen> createState() =>
      _AuthenticateWithOAuthScreenState();
}

class _AuthenticateWithOAuthScreenState
    extends State<AuthenticateWithOAuthScreen> {
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    late Widget body;

    if (!_isAuthenticated) {
      body = Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ArcGISCredentialStore().addOAuthCredential(
                portalUrl:
                    'https://www.arcgis.com/home/item.html?id=e5039444ef3c48b8a8fdc9227f9be7c1',
                clientId: 'lgAdHkYZYlwwfAhC',
                redirectUri: 'my-ags-app://auth',
              );
              setState(() {
                _isAuthenticated = true;
              });
            } catch (exception) {
              debugPrint(exception.toString());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(exception.toString()),
                  ),
                );
              }
            }
          },
          child: const Text('Authenticate'),
        ),
      );
    } else {
      body = const Center(
        child: Text('Authenticated'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticate with OAuth'),
      ),
      body: body,
    );
  }
}
