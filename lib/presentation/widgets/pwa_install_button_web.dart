import 'package:flutter/material.dart';
import 'dart:html' as html;
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
    _setupPWAListeners();
  }

  void _setupPWAListeners() {
    html.window.addEventListener('pwa-installable', (_) {
      if (mounted) {
        setState(() {
          _isInstallable = true;
        });
      }
    });

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
    js.context.callMethod('triggerPWAInstall');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInstallable || _isInstalled) {
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
