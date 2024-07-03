import 'package:flutter/material.dart';
import 'package:flutter_pagination/dto/book.dart';
import 'BookDetailPage.dart';

class WishlistPage extends StatelessWidget {
  final String token;
  final List<BookDTO> wishlist;
  final Function(BookDTO) onRemoveFromWishlist;

  WishlistPage({
    required this.token,
    required this.wishlist,
    required this.onRemoveFromWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: wishlist.isEmpty
          ? Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final book = wishlist[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(
                            book: book,
                            onAddToWishlist: () {},
                            onBuyBook: () {},
                          ),
                        ),
                      );
                    },
                    title: Text('Name: ${book.name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: ${book.price}'),
                        Text('Description: ${book.desc}'),
                      ],
                    ),
                    trailing: book.imagePath != null
                        ? Image.network(
                            book.imagePath!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : SizedBox.shrink(),
                    leading: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => onRemoveFromWishlist(book),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
