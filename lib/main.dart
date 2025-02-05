import 'dart:html' as html;
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String? _imageUrl;
  bool _isMenuOpen = false;

  late html.ImageElement _imageElement;

  @override
  void initState() {
    super.initState();
    _imageElement = html.ImageElement();
    _registerImageElement();
  }

  void _registerImageElement() {
    platformViewRegistry.registerViewFactory(
      'imageElement',
      (int viewId) {
        _imageElement
          ..style.width = '100%'
          ..style.height = '100%'
          ..onDoubleClick.listen((_) => _toggleFullscreen());
        return _imageElement;
      },
    );
  }

  void _setImageUrl() {
    setState(() {
      _imageUrl = _urlController.text;
      _imageElement.src = _imageUrl!;  
    });
  }

  void _toggleFullscreen() {
    html.document.fullscreenElement == null
        ? html.document.documentElement?.requestFullscreen()
        : html.document.exitFullscreen();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Viewer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _imageUrl == null
                    ? const Text('Введите URL изображения')
                    : HtmlElementView(viewType: 'imageElement'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _setImageUrl,
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (_isMenuOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(color: Colors.black54),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 110,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MenuButton(
                        label: 'Enter fullscreen',
                        onPressed: _toggleFullscreen),
                    _MenuButton(
                        label: 'Exit fullscreen', onPressed: _toggleFullscreen),
                  ],
                ),
              ),
            ),
          ],
          Positioned(
            right: 16,
            bottom: 50,
            child: FloatingActionButton(
              onPressed: _toggleMenu,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MenuButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}