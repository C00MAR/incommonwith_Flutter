import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class PWAInstallButton extends StatefulWidget {
  const PWAInstallButton({super.key});

  @override
  State<PWAInstallButton> createState() => _PWAInstallButtonState();
}

class _PWAInstallButtonState extends State<PWAInstallButton> {
  bool _isInstallable = false;
  bool _isInstalled = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _setupPWAListeners();
    }
  }

  void _setupPWAListeners() {
    // Écouter l'événement custom 'pwa-installable'
    html.window.addEventListener('pwa-installable', (_) {
      if (mounted) {
        setState(() {
          _isInstallable = true;
        });
      }
    });

    // Écouter l'événement custom 'pwa-installed'
    html.window.addEventListener('pwa-installed', (_) {
      if (mounted) {
        setState(() {
          _isInstalled = true;
          _isInstallable = false;
        });
      }
    });
  }

  void _triggerInstall() {
    if (kIsWeb) {
      js.context.callMethod('triggerPWAInstall');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ne rien afficher si pas sur web, pas installable ou déjà installé
    if (!kIsWeb || !_isInstallable || _isInstalled) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: _triggerInstall,
        icon: const Icon(Icons.download, size: 16),
        label: const Text('Installer l\'app'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A1D0F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
