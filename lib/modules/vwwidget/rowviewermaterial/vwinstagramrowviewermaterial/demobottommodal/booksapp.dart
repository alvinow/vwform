import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/vwwidget/rowviewermaterial/vwinstagramrowviewermaterial/demobottommodal/demobotoommodal.dart';

class BooksApp extends StatefulWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin', Colors.red),
    Book('Too Like the Lightning', 'Ada Palmer', Colors.green),
    Book('Kindred', 'Octavia E. Butler', Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoModalSheetRoute(
              settings: settings,
              builder: (BuildContext context) {
                return BooksListScreen(
                  books: books,
                  onTapped: (book) {
                    _showDetails(context, book, (context) {
                      _showDetails(context, book, (context) {
                        _showDetails(context, book, (context) {
                          _showDetailsOnNestedNavigator(context, book,
                                  (context) {
                                _pushDetails(context, book, (context) {
                                  _pushDetails(context, book, (context) {
                                    _showDetails(context, book, null);
                                  });
                                });
                              });
                        });
                      });
                    });
                  },
                );
              },
            );
        }
        return null;
      },
    );
  }

  void _showDetails(
      BuildContext context, Book book, Function(BuildContext)? onPressed) {
    showCupertinoModalSheet(
      context: context,
      builder: (context) => BookDetailsScreen(
        book: book,
        onPressed: onPressed == null ? null : () => onPressed(context),
      ),
    );
  }

  void _pushDetails(
      BuildContext context, Book book, Function(BuildContext)? onPressed) {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: ((context) => BookDetailsScreen(
          book: book,
          onPressed: () => onPressed?.call(context),
        ))));
  }

  void _showDetailsOnNestedNavigator(
      BuildContext context, Book book, Function(BuildContext)? onPressed) {
    final nav = Navigator(
      observers: [HeroController()],
      onGenerateRoute: (settings) => CupertinoPageRoute(
        builder: ((context) {
          return BookDetailsScreen(
            book: book,
            onPressed: () => onPressed?.call(context),
          );
        }),
      ),
    );
    showCupertinoModalSheet(
      context: context,
      builder: (context) => nav,
    );
  }
}