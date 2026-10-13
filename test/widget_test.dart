import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_bookstore/main.dart';

void main() {
  testWidgets('alur katalog, badge, keranjang, dan checkout', (tester) async {
    await tester.pumpWidget(const NusaBookstoreApp());

    expect(find.text('NusaBookstore'), findsOneWidget);
    expect(find.text('Katalog'), findsOneWidget);

    // Menambah buku menaikkan badge keranjang.
    expect(find.byType(Badge), findsOneWidget);
    await tester.tap(find.text('Tambah ke Keranjang').first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(Badge, '1'), findsOneWidget);

    await tester.tap(find.text('Tambah ke Keranjang').first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(Badge, '2'), findsOneWidget);

    // Membuka keranjang dan memeriksa total pembayaran.
    await tester.tap(find.byTooltip('Buka keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Belanja'), findsOneWidget);
    expect(find.text('Total Pembayaran'), findsOneWidget);

    // Checkout mengosongkan keranjang dan menampilkan SnackBar.
    await tester.tap(find.text('Bayar Sekarang'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('berhasil'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });

  testWidgets('tombol tema mengganti mode terang dan gelap', (tester) async {
    await tester.pumpWidget(const NusaBookstoreApp());

    expect(find.byTooltip('Aktifkan mode gelap'), findsOneWidget);
    await tester.tap(find.byTooltip('Aktifkan mode gelap'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Aktifkan mode terang'), findsOneWidget);
    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}
