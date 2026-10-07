import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nisController;
  final TextEditingController namaController;
  final TextEditingController tempatLahirController;
  final TextEditingController tanggalLahirController;
  final TextEditingController kelaminController;
  final TextEditingController agamaController;
  final TextEditingController alamatController;

  const AppForm({
    super.key,
    required this.formKey,
    required this.nisController,
    required this.namaController,
    required this.tempatLahirController,
    required this.tanggalLahirController,
    required this.kelaminController,
    required this.agamaController,
    required this.alamatController,
  });

  static const _genders = ['Laki-laki', 'Perempuan'];
  static const _religions = ['Islam', 'Katolik', 'Protestan', 'Hindu', 'Buddha', 'Khonghucu'];

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      );

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(controller: nisController, decoration: _decoration('NIS', Icons.badge_outlined), keyboardType: TextInputType.number, validator: _required),
          const SizedBox(height: 14),
          TextFormField(controller: namaController, decoration: _decoration('Nama lengkap', Icons.person_outline), validator: _required),
          const SizedBox(height: 14),
          TextFormField(controller: tempatLahirController, decoration: _decoration('Tempat lahir', Icons.location_city_outlined), validator: _required),
          const SizedBox(height: 14),
          TextFormField(
            controller: tanggalLahirController,
            readOnly: true,
            decoration: _decoration('Tanggal lahir', Icons.calendar_today_outlined),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.tryParse(tanggalLahirController.text) ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                tanggalLahirController.text = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              }
            },
            validator: _required,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _genders.contains(kelaminController.text) ? kelaminController.text : null,
            decoration: _decoration('Jenis kelamin', Icons.people_outline),
            items: _genders.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) => kelaminController.text = value ?? '',
            validator: (value) => value == null ? 'Pilih jenis kelamin' : null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _religions.contains(agamaController.text) ? agamaController.text : null,
            decoration: _decoration('Agama', Icons.mosque_outlined),
            items: _religions.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) => agamaController.text = value ?? '',
            validator: (value) => value == null ? 'Pilih agama' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(controller: alamatController, decoration: _decoration('Alamat', Icons.home_outlined), maxLines: 3, validator: _required),
        ],
      ),
    );
  }
}