import 'package:flutter/foundation.dart';

import '../models/book.dart';

/// Satu baris di keranjang: buku beserta jumlahnya.
class CartItem {
  CartItem({required this.book, this.quantity = 1});

  final Book book;
  int quantity;

  int get subtotal => book.price * quantity;
}

/// Menyimpan isi keranjang belanja dan memberitahu listener pada setiap perubahan.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Jumlah seluruh buku, dihitung dari kuantitas tiap baris.
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Total harga seluruh keranjang dalam rupiah.
  int get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);

  /// Menambah buku baru, atau menaikkan jumlahnya bila buku itu sudah ada.
  void addItem(Book book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);
    if (index == -1) {
      _items.add(CartItem(book: book));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  /// Mengurangi jumlah buku. Baris dihapus saat jumlahnya mencapai nol.
  void removeItem(Book book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);
    if (index == -1) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
