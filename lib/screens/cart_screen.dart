import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';

/// Warna punggung buku, dipilih dari [book.id] supaya sampul deterministik.
const List<Color> _spineColors = [
  Color(0xFF23503F),
  Color(0xFF6B4F2A),
  Color(0xFF7A3B34),
  Color(0xFF37506B),
  Color(0xFF5B6B3A),
  Color(0xFF6A3F63),
];

/// Placeholder sampul berbentuk punggung buku, dipakai katalog dan keranjang.
///
/// Katalog contoh tidak punya berkas cover asli, jadi sampul dirender dari
/// judul dan palet, bukan gambar karangan.
class BookSpine extends StatelessWidget {
  const BookSpine({
    super.key,
    required this.book,
    this.width = 52,
    this.height = 74,
  });

  final Book book;
  final double width;
  final double height;

  Color get _color {
    final seed = book.id.codeUnits.fold<int>(0, (sum, code) => sum + code);
    return _spineColors[seed % _spineColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final title = book.title.trim();
    final initial = title.isEmpty ? '?' : title[0].toUpperCase();

    return Semantics(
      image: true,
      label: 'Sampul ${book.title}',
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Positioned(
              left: width * 0.12,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontSize: height * 0.42,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) return const _EmptyCart();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: cart.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _CartRow(item: cart.items[index]),
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) => cart.isEmpty
            ? const SizedBox.shrink()
            : _CheckoutPanel(
                totalItems: cart.totalItems,
                totalPrice: cart.totalPrice,
                onCheckout: () => _checkout(context, cart),
              ),
      ),
    );
  }

  void _checkout(BuildContext context, CartProvider cart) {
    final items = cart.totalItems;
    final total = formatRupiah(cart.totalPrice);
    final messenger = ScaffoldMessenger.of(context);
    cart.clearCart();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Pembayaran $total berhasil. $items buku dihapus dari keranjang.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item});

  final CartItem item;

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
                BookSpine(book: item.book, width: 44, height: 62),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.book.title, style: text.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        '${formatRupiah(item.book.price)} / buku',
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatRupiah(item.subtotal),
                  style: text.labelLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Jumlah', style: text.bodyMedium),
                const Spacer(),
                _QuantityStepper(item: item),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            tooltip: 'Kurangi jumlah ${item.book.title}',
            onPressed: () =>
                context.read<CartProvider>().removeItem(item.book),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            tooltip: 'Tambah jumlah ${item.book.title}',
            onPressed: () => context.read<CartProvider>().addItem(item.book),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      padding: EdgeInsets.zero,
    );
  }
}

class _CheckoutPanel extends StatelessWidget {
  const _CheckoutPanel({
    required this.totalItems,
    required this.totalPrice,
    required this.onCheckout,
  });

  final int totalItems;
  final int totalPrice;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: theme.colorScheme.outline)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Total Item', style: text.bodyMedium),
                  const Spacer(),
                  Text('$totalItems buku', style: text.titleSmall),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Pembayaran', style: text.bodyMedium),
                  const Spacer(),
                  Text(
                    formatRupiah(totalPrice),
                    style: text.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onCheckout,
                  child: const Text('Bayar Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text('Keranjang masih kosong', style: text.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Tambahkan buku dari katalog untuk mulai berbelanja.',
              style: text.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Kembali ke katalog'),
            ),
          ],
        ),
      ),
    );
  }
}
