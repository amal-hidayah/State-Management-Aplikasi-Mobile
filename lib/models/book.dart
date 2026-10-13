/// Satu judul buku di katalog NusaBookstore.
///
/// Harga disimpan sebagai bilangan bulat rupiah (tanpa sen) agar perhitungan
/// total tidak terkena galat pembulatan bilangan pecahan.
class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String author;
  final int price;

  /// URL cover bila tersedia. Bila null, UI menampilkan punggung buku
  /// tipografis sebagai placeholder yang jujur.
  final String? imageUrl;
}

/// Format bilangan bulat rupiah menjadi teks bergaya Indonesia,
/// misalnya 135000 menjadi "Rp 135.000".
String formatRupiah(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'Rp ${amount < 0 ? '-' : ''}$buffer';
}
