import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwqueryresult/vwqueryresult.dart';
import 'package:matrixclient2base/modules/base/vwremotefunctioncall/vwremotefunctioncall.dart';

import 'package:uuid/uuid.dart';


typedef VwLongListRemoteFunction = Future<VwQueryResult > Function(VwRemoteFunctionCall  );
typedef VwLongListWidgetBuilder = Widget Function(BuildContext, VwRowData);

class VwLongListBuilder extends StatefulWidget {
  VwLongListBuilder({Key? key,
    required this.dataFetcher,
    required this.listWidgetBuilder,
  }):super(key: key);

  final VwLongListRemoteFunction dataFetcher;
  final VwLongListWidgetBuilder listWidgetBuilder;

  @override
  _VwLongListState createState() => _VwLongListState();
}

class _VwLongListState extends State<VwLongListBuilder> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  late final List<VwRowData> rows;
  late bool isHasReachedMax;

  Widget implementItemBuilder(BuildContext context, int rowNumber) {
    return this.widget.listWidgetBuilder(context, rows.elementAt(rowNumber));
  }

  @override
  void initState() {
    super.initState();
    this._scrollController.addListener(_onScroll);
    this.isHasReachedMax = false;
    this.rows = <VwRowData>[];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VwQueryResult>(
        future: this._fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                controller: this._scrollController,
                itemCount: this.rows.length,
                itemBuilder: (context, index) {
                  return this.implementItemBuilder(context, index);
                });
          } else {
            return const Text('DataNotFound');
          }
        });
  }

  Future<VwQueryResult> _fetchData() async {

    VwRemoteFunctionCall remoteFunctionCall=VwRemoteFunctionCall(remoteFunctionCallId: 'call', remoteFunctionId: 'fetchExample1', token: Uuid().v4(), parameters: <VwRowData>[]);

    VwQueryResult queryResult = await this.widget.dataFetcher(remoteFunctionCall);

    if (queryResult.rows.length > 0) {
      this.rows.addAll(queryResult.rows);
    }

    return queryResult;
  }

  void _onScroll() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      await this._fetchData();

      setState(() {});
    }
  }
}
