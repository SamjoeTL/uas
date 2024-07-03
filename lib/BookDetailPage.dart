import 'package:flutter/material.dart';
import 'package:flutter_pagination/dto/book.dart';

class BookDetailPage extends StatelessWidget {
  final BookDTO book;
  final VoidCallback onAddToWishlist;
  final VoidCallback onBuyBook;

  BookDetailPage({
    required this.book,
    required this.onAddToWishlist,
    required this.onBuyBook,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name ?? 'Book Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.imagePath != null)
              Center(
                child: Image.network(
                  book.imagePath!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    book.name ?? 'Book Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: onAddToWishlist,
                      tooltip: 'Add to Wishlist',
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: onBuyBook,
                      tooltip: 'Buy Book',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${book.status}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[800],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Text(
                '\$${book.price}',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              book.desc ?? 'No description available.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Created At: ${book.createdAt}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Updated At: ${book.updatedAt}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
