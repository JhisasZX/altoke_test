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
    final cubit = context.read<PostsCubit>();
    await cubit.addPost(
        title: _titleCtl.text.trim(),
        body: _bodyCtl.text.trim(),
        userId: int.parse(_userIdCtl.text.trim()));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post guardado exitosamente')));
    Navigator.pop(context);
  }

  // Validación para solo caracteres (sin números ni caracteres especiales)
  String? _validateOnlyCharacters(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return 'Solo se permiten caracteres, los números y caracteres especiales no son permitidos';
    }
    return null;
  }

  // Validación para solo números
  String? _validateOnlyNumbers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Solo se permiten números';
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
                TextFormField(
                  controller: _titleCtl,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateOnlyCharacters,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyCtl,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: _validateOnlyCharacters,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userIdCtl,
                  decoration: const InputDecoration(
                    labelText: 'Id de usuario',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
