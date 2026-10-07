import 'package:flutter/material.dart';

import '../models/api.dart';
import '../models/msiswa.dart';
import '../widgets/form.dart';

class Edit extends StatefulWidget {
  final SiswaModel siswa;
  const Edit({super.key, required this.siswa});
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  final _api = ApiService();
  bool _saving = false;

  @override
  void initState() { super.initState(); _controllers = [widget.siswa.nis, widget.siswa.nama, widget.siswa.tempatLahir, widget.siswa.tanggalLahir, widget.siswa.kelamin, widget.siswa.agama, widget.siswa.alamat].map((value) => TextEditingController(text: value)).toList(); }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _api.updateSiswa({'id': '${widget.siswa.id}', 'nis': _controllers[0].text, 'nama': _controllers[1].text, 'tplahir': _controllers[2].text, 'tglahir': _controllers[3].text, 'kelamin': _controllers[4].text, 'agama': _controllers[5].text, 'alamat': _controllers[6].text});
      if (mounted) Navigator.pop(context, true);
    } catch (error) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error'))); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  void dispose() { for (final controller in _controllers) { controller.dispose(); } super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Edit Siswa')), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: AppForm(formKey: _formKey, nisController: _controllers[0], namaController: _controllers[1], tempatLahirController: _controllers[2], tanggalLahirController: _controllers[3], kelaminController: _controllers[4], agamaController: _controllers[5], alamatController: _controllers[6])), bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.check), label: Text(_saving ? 'Memperbarui...' : 'Update')))));
}