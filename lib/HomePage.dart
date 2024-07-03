import 'package:flutter/material.dart';
import 'package:flutter_pagination/dto/book.dart';
import 'package:flutter_pagination/book_service.dart';
import 'add_book_page.dart';
import 'update_book_page.dart';
import 'wishlist.dart';
import 'BookDetailPage.dart';

class HomePage extends StatefulWidget {
  final String token;

  HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BookService _bookService = BookService();
  List<BookDTO> _books = [];
  List<BookDTO> _wishlist = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchBooks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<BookDTO> books = await _bookService.getBooks(widget.token, _page, query: _query);
      setState(() {
        _page++;
        _books.addAll(books);
        if (books.length < 10) {
          _hasMore = false;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    setState(() {
      _books.clear();
      _page = 1;
      _hasMore = true;
      _fetchBooks();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _deleteBook(int bookId) async {
    try {
      await _bookService.deleteBook(widget.token, bookId);
      setState(() {
        _books.removeWhere((book) => book.id == bookId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete book: $e')),
      );
    }
  }

  void _addToWishlist(BookDTO book) {
    setState(() {
      _wishlist.add(book);
    });
  }

  void _removeFromWishlist(BookDTO book) {
    setState(() {
      _wishlist.remove(book);
    });
  }

  void _buyBook(BookDTO book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchased ${book.name} for \$${book.price}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildHomePage(),
          WishlistPage(
            token: widget.token,
            wishlist: _wishlist,
            onRemoveFromWishlist: _removeFromWishlist,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alpha Books'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookPage(token: widget.token)),
              );
              if (result == true) {
                _onSearch();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _query = value;
                  _onSearch();
                });
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _books.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _books.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(
                              book: _books[index],
                              onAddToWishlist: () => _addToWishlist(_books[index]),
                              onBuyBook: () => _buyBook(_books[index]),
                            ),
                          ),
                        );
                      },
                      child: ResponsiveCard(
                        book: _books[index],
                        onDelete: () => _deleteBook(_books[index].id!),
                        onUpdate: () async {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateBookPage(token: widget.token, book: _books[index]),
                            ),
                          );
                          if (result == true) {
                            _onSearch();
                          }
                        },
                        onAddToWishlist: () => _addToWishlist(_books[index]),
                      ),
                    );
                  },
                ),
                if (_isLoading)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final BookDTO book;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback onAddToWishlist;

  ResponsiveCard({
    required this.book,
    required this.onDelete,
    required this.onUpdate,
    required this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${book.name}'),
            Text('Price: ${book.price}'),
            Text('Description: ${book.desc}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: onAddToWishlist,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onUpdate,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
