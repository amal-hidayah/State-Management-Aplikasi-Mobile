import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

/// Data katalog contoh.
///
/// Judul dan penulis memakai buku nyata agar tidak ada identitas karangan.
/// Harganya contoh harga toko, bukan data penjualan langsung.
const List<Book> katalogBuku = [
  Book(id: 'b001', title: 'Laskar Pelangi', author: 'Andrea Hirata', price: 95000),
  Book(id: 'b002', title: 'Bumi Manusia', author: 'Pramoedya Ananta Toer', price: 135000),
  Book(id: 'b003', title: 'Perahu Kertas', author: 'Dee Lestari', price: 105000),
  Book(id: 'b004', title: 'Cantik Itu Luka', author: 'Eka Kurniawan', price: 120000),
  Book(id: 'b005', title: 'Negeri 5 Menara', author: 'Ahmad Fuadi', price: 98000),
  Book(id: 'b006', title: 'Pulang', author: 'Leila S. Chudori', price: 125000),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          IconButton(
            tooltip: theme.isDark
                ? 'Aktifkan mode terang'
                : 'Aktifkan mode gelap',
            icon: Icon(
              theme.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, _) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Badge(
                isLabelVisible: cart.totalItems > 0,
                label: Text('${cart.totalItems}'),
                child: IconButton(
                  tooltip: 'Buka keranjang',
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: katalogBuku.isEmpty
          ? const _EmptyCatalog()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: katalogBuku.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _CatalogIntro(count: katalogBuku.length);
                }
                return _BookCard(book: katalogBuku[index - 1]);
              },
            ),
    );
  }
}

class _CatalogIntro extends StatelessWidget {
  const _CatalogIntro({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Katalog', style: text.titleLarge),
          const SizedBox(height: 2),
          Text('$count judul siap dikirim', style: text.bodyMedium),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookSpine(book: book),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: text.titleMedium),
                      const SizedBox(height: 2),
                      Text(book.author, style: text.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        formatRupiah(book.price),
                        style: text.labelLarge?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _add(context),
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Tambah ke Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _add(BuildContext context) {
    context.read<CartProvider>().addItem(book);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${book.title} ditambahkan ke keranjang.'),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 40, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('Katalog masih kosong', style: text.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Belum ada judul yang bisa ditampilkan di sini.',
              style: text.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
