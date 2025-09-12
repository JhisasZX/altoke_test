import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/posts_cubit.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});
  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _bodyCtl = TextEditingController();
  final _userIdCtl = TextEditingController();

  @override
  void dispose() {
    _titleCtl.dispose();
    _bodyCtl.dispose();
    _userIdCtl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final cubit = context.read<PostsCubit>();
      await cubit.addPost(
          title: _titleCtl.text.trim(),
          body: _bodyCtl.text.trim(),
          userId: int.parse(_userIdCtl.text.trim()));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post guardado exitosamente')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      String errorMessage = 'Error al guardar el post';

      if (e is FormatException) {
        errorMessage =
            'El ID de usuario contiene un valor inválido. Por favor, ingrese un número válido.';
      } else if (e.toString().contains('Positive input exceeds the limit')) {
        errorMessage =
            'El ID de usuario es demasiado grande. Por favor, ingrese un número más pequeño.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Validación para solo caracteres con límite de longitud (para título)
  String? _validateOnlyCharacters(String? value, {int maxLength = 100}) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length > maxLength) {
      return 'Máximo $maxLength caracteres permitidos';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return 'Los números y caracteres especiales no son permitidos';
    }
    return null;
  }

  // Validación para descripción (permite números y caracteres especiales)
  String? _validateDescription(String? value, {int maxLength = 200}) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length > maxLength) {
      return 'Máximo $maxLength caracteres permitidos';
    }
    return null;
  }

  // Validación para solo números con límite de 4 dígitos
  String? _validateOnlyNumbers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Solo se permiten números';
    }

    // Verificar que no exceda 4 dígitos
    if (value.length > 4) {
      return 'Máximo 4 dígitos permitidos';
    }

    // Verificar que el número sea positivo
    try {
      final intValue = int.parse(value);
      if (intValue < 0) {
        return 'El valor debe ser positivo';
      }
    } catch (e) {
      return 'Número inválido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleCtl,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                    helperText: 'Máximo 50 caracteres',
                  ),
                  maxLength: 50,
                  validator: (value) =>
                      _validateOnlyCharacters(value, maxLength: 50),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyCtl,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    helperText: 'Máximo 200 caracteres',
                  ),
                  maxLines: 4,
                  maxLength: 200,
                  validator: (value) =>
                      _validateDescription(value, maxLength: 200),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userIdCtl,
                  decoration: const InputDecoration(
                    labelText: 'Id de usuario',
                    border: OutlineInputBorder(),
                    helperText: 'Máximo 4 dígitos',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4, // Límite de 5 dígitos
                  validator: _validateOnlyNumbers,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('GUARDAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
