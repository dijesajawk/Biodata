import 'package:flutter/material.dart';

import '../models/api.dart';
import '../models/msiswa.dart';
import 'create.dart';
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _api = ApiService();
  List<SiswaModel> _siswa = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  Future<void> _loadSiswa() async {
    if (mounted) setState(() { _loading = true; _error = null; });
    try {
      final latest = await _api.getSiswa();
      if (mounted) setState(() { _siswa = latest; _loading = false; });
    } catch (error) {
      if (mounted) setState(() { _error = '$error'; _loading = false; });
    }
  }

  Future<void> _openCreate() async {
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const Create()));
    if (changed == true) await _loadSiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Siswa'),
        centerTitle: true,
        actions: [IconButton(onPressed: _loading ? null : _loadSiswa, icon: const Icon(Icons.refresh), tooltip: 'Muat ulang')],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        tooltip: 'Tambah siswa',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off, size: 48), const SizedBox(height: 12), const Text('Tidak dapat terhubung ke API.', textAlign: TextAlign.center), const SizedBox(height: 6), Text(_error!, textAlign: TextAlign.center), const SizedBox(height: 16), OutlinedButton.icon(onPressed: _loadSiswa, icon: const Icon(Icons.refresh), label: const Text('Coba lagi'))])));
    if (_siswa.isEmpty) return const Center(child: Text('Belum ada data siswa.'));
    return RefreshIndicator(onRefresh: _loadSiswa, child: ListView.separated(padding: const EdgeInsets.all(16), itemCount: _siswa.length, separatorBuilder: (_, _) => const SizedBox(height: 10), itemBuilder: (context, index) => _SiswaTile(siswa: _siswa[index], onChanged: _loadSiswa)));
  }
}

class _SiswaTile extends StatelessWidget {
  final SiswaModel siswa;
  final Future<void> Function() onChanged;

  const _SiswaTile({required this.siswa, required this.onChanged});

  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: CircleAvatar(child: Text(siswa.nama.isEmpty ? '?' : siswa.nama[0].toUpperCase())), title: Text(siswa.nama, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('NIS ${siswa.nis}\n${siswa.tempatLahir}, ${siswa.tanggalLahir}'), isThreeLine: true, trailing: const Icon(Icons.chevron_right), onTap: () async { final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => Details(siswa: siswa))); if (changed == true) await onChanged(); }));
}