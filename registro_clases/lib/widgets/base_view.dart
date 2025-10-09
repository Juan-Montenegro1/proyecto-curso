import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_drawer.dart'; // Importa el Drawer personalizado

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  // Si true muestra el botón de regresar en el AppBar y oculta el Drawer
  final bool showBackButton;
  // Ruta a la que se navegará al presionar el botón de volver. Si es null, usa Navigator.pop().
  final String? backRoute;

  const BaseView({super.key, required this.title, required this.body, this.showBackButton = false, this.backRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? (backRoute != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go(backRoute!),
                  )
                : const BackButton())
            : null,
      ),
      drawer: showBackButton ? null : const CustomDrawer(), // Oculta drawer si mostramos back
      body: body,
    );
  }
}
