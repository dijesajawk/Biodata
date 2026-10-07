import 'package:flutter/material.dart';

import '../models/api.dart';
import '../models/msiswa.dart';
import 'edit.dart';

class Details extends StatefulWidget {
  final SiswaModel siswa;
  const Details({super.key, required this.siswa});
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _api = ApiService();
  bool _deleting = false;

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Hapus data?'), content: Text('Data ${widget.siswa.nama} akan dihapus permanen.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus'))])) ?? false;
    if (!confirmed) return;
    setState(() => _deleting = true);
    try { await _api.deleteSiswa(widget.siswa.id); if (mounted) Navigator.pop(context, true); } catch (error) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error'))); } finally { if (mounted) setState(() => _deleting = false); }
  }

  @override
  Widget build(BuildContext context) {
    final fields = {'NIS': widget.siswa.nis, 'Nama': widget.siswa.nama, 'Tempat lahir': widget.siswa.tempatLahir, 'Tanggal lahir': widget.siswa.tanggalLahir, 'Jenis kelamin': widget.siswa.kelamin, 'Agama': widget.siswa.agama, 'Alamat': widget.siswa.alamat};
    return Scaffold(appBar: AppBar(title: const Text('Detail Siswa'), actions: [IconButton(onPressed: _deleting ? null : _delete, icon: const Icon(Icons.delete_outline), tooltip: 'Hapus')]), body: ListView(padding: const EdgeInsets.all(20), children: [CircleAvatar(radius: 38, child: Text(widget.siswa.nama.isEmpty ? '?' : widget.siswa.nama[0].toUpperCase(), style: const TextStyle(fontSize: 28))), const SizedBox(height: 24), ...fields.entries.map((entry) => ListTile(contentPadding: EdgeInsets.zero, title: Text(entry.key, style: Theme.of(context).textTheme.labelMedium), subtitle: Text(entry.value, style: Theme.of(context).textTheme.titleMedium))), const SizedBox(height: 16), FilledButton.icon(onPressed: () async { final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => Edit(siswa: widget.siswa))); if (!context.mounted) return; if (changed == true) Navigator.pop(context, true); }, icon: const Icon(Icons.edit), label: const Text('Edit data'))]));
  }
}