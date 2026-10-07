import 'package:flutter/material.dart';

import '../models/api.dart';
import '../widgets/form.dart';

class Create extends StatefulWidget {
  const Create({super.key});
  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(7, (_) => TextEditingController());
  final _api = ApiService();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _api.createSiswa({'nis': _controllers[0].text, 'nama': _controllers[1].text, 'tplahir': _controllers[2].text, 'tglahir': _controllers[3].text, 'kelamin': _controllers[4].text, 'agama': _controllers[5].text, 'alamat': _controllers[6].text});
      if (mounted) Navigator.pop(context, true);
    } catch (error) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error'))); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  void dispose() { for (final controller in _controllers) { controller.dispose(); } super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Tambah Siswa')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: AppForm(formKey: _formKey, nisController: _controllers[0], namaController: _controllers[1], tempatLahirController: _controllers[2], tanggalLahirController: _controllers[3], kelaminController: _controllers[4], agamaController: _controllers[5], alamatController: _controllers[6])), bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: FilledButton.icon(onPressed: _saving ? null : _save, icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save), label: Text(_saving ? 'Menyimpan...' : 'Simpan')))));
}