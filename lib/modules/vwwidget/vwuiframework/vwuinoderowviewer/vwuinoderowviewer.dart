import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';

class VwUiNodeRowViewer extends StatelessWidget {
  VwUiNodeRowViewer({
    required this.recordId,
    required this.rowNode,
    required this.highlightedText,
    required this.parentBloc,
  });

  final String recordId;
  final VwNode rowNode;
  final String? highlightedText;
  final Bloc parentBloc;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("(Unimplemented Error)"));
  }
}
