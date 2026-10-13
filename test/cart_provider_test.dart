import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_bookstore/models/book.dart';
import 'package:nusa_bookstore/providers/cart_provider.dart';

const _bookA = Book(id: 'a', title: 'Buku A', author: 'Penulis A', price: 10000);
const _bookB = Book(id: 'b', title: 'Buku B', author: 'Penulis B', price: 25000);

void main() {
  group('CartProvider', () {
    test('keranjang mulai kosong', () {
      final cart = CartProvider();
      expect(cart.isEmpty, isTrue);
      expect(cart.totalItems, 0);
      expect(cart.totalPrice, 0);
    });

    test('addItem menambah buku baru sebagai satu baris', () {
      final cart = CartProvider();
      cart.addItem(_bookA);
      expect(cart.items.length, 1);
      expect(cart.items.single.quantity, 1);
      expect(cart.totalItems, 1);
      expect(cart.totalPrice, 10000);
    });

    test('addItem pada buku yang sama menaikkan jumlah, bukan menambah baris', () {
      final cart = CartProvider();
      cart.addItem(_bookA);
      cart.addItem(_bookA);
      expect(cart.items.length, 1);
      expect(cart.items.single.quantity, 2);
      expect(cart.totalItems, 2);
      expect(cart.totalPrice, 20000);
    });

    test('removeItem mengurangi jumlah lalu menghapus baris di nol', () {
      final cart = CartProvider();
      cart.addItem(_bookA);
      cart.addItem(_bookA);
      cart.removeItem(_bookA);
      expect(cart.items.single.quantity, 1);
      cart.removeItem(_bookA);
      expect(cart.isEmpty, isTrue);
    });

    test('removeItem pada buku yang tidak ada tidak mengubah apa pun', () {
      final cart = CartProvider();
      cart.addItem(_bookA);
      cart.removeItem(_bookB);
      expect(cart.items.length, 1);
      expect(cart.totalItems, 1);
    });

    test('totalItems dan totalPrice menjumlahkan seluruh baris', () {
      final cart = CartProvider();
      cart.addItem(_bookA);
      cart.addItem(_bookA);
      cart.addItem(_bookB);
      expect(cart.totalItems, 3);
      expect(cart.totalPrice, 10000 * 2 + 25000);
    });

    test('clearCart mengosongkan keranjang', () {
      final cart = CartProvider();
      cart.addItem(_bookA);
      cart.addItem(_bookB);
      cart.clearCart();
      expect(cart.isEmpty, isTrue);
      expect(cart.totalItems, 0);
    });

    test('setiap perubahan memberitahu listener', () {
      final cart = CartProvider();
      var notifications = 0;
      cart.addListener(() => notifications++);

      cart.addItem(_bookA);
      cart.addItem(_bookA);
      cart.removeItem(_bookA);
      cart.clearCart();

      expect(notifications, 4);
    });
  });
}
