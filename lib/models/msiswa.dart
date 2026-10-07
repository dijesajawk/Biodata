class SiswaModel {
  final int id;
  final String nis;
  final String nama;
  final String tempatLahir;
  final String tanggalLahir;
  final String kelamin;
  final String agama;
  final String alamat;

  const SiswaModel({
    required this.id,
    required this.nis,
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.kelamin,
    required this.agama,
    required this.alamat,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      id: int.tryParse('${json['id']}') ?? 0,
      nis: '${json['nis'] ?? ''}',
      nama: '${json['nama'] ?? ''}',
      tempatLahir: '${json['tplahir'] ?? ''}',
      tanggalLahir: '${json['tglahir'] ?? ''}',
      kelamin: '${json['kelamin'] ?? ''}',
      agama: '${json['agama'] ?? ''}',
      alamat: '${json['alamat'] ?? ''}',
    );
  }
}