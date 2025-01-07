import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final Color color;

  Book(this.title, this.author, this.color);
}

class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  const BooksListScreen({
    Key? key,
    required this.books,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text('Book List'),
      ),
      child: SafeArea(
        child: Material(
          child: ListView(
            children: [
              for (var book in books)
                ListTile(
                  leading: Hero(
                    tag: book,
                    child: Container(color: book.color, height: 50, width: 50),
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () => onTapped(book),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final Function()? onPressed;

  const BookDetailsScreen({
    Key? key,
    required this.book,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(book.title),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                    tag: book,
                    child: Container(
                      color: book.color,
                      height: 50,
                      width: 50,
                    )),
                Text(book.title, style: Theme.of(context).textTheme.titleLarge),
                Text(book.author,
                    style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton(onPressed: onPressed, child: const Text('next')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}