import 'package:flutter/material.dart';

class TextSearchResultDelegate extends SingleChildLayoutDelegate{
  // final Size _anchorSize ;
  // _TextSearchResultDelegate(this._anchorSize);
  final ValueNotifier<Size> _size;
  final double minHeight;
  final double maxHeight;
  // final double _width ;
  // final int rows ;
  TextSearchResultDelegate(this._size, {required this.minHeight, required this.maxHeight}) : super(relayout: _size) ;
  // TextSearchResultDelegate(this._size, {this.rows=0}) : _width = _size.value.width, super(relayout: _size) ;

  @override
  Size getSize(BoxConstraints constraints) {
    debugPrint('TextSearchResultDelegate: getSize(): width=${_size.value.width}, minHeight=$minHeight, maxHeight=$maxHeight, constraints=${constraints} -------');
    // Use constraints from parent (ConstrainedBox) if available, otherwise use maxHeight
    // This allows the ConstrainedBox to properly constrain the layout
    final double height = constraints.hasBoundedHeight && constraints.maxHeight < double.infinity
        ? constraints.maxHeight
        : maxHeight;
    return Size(_size.value.width, height);
  } // constraints.smallest ;

  @override
  // BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>  constraints.loosen();
  // BoxConstraints getConstraintsForChild(BoxConstraints constraints) => BoxConstraints(maxWidth: _anchorSize.width, maxHeight: _anchorSize.height, minHeight: 64);
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Pass constraints with width from _size, and min/max height - child will size itself within these bounds
    return BoxConstraints(
      minWidth: _size.value.width,
      maxWidth: _size.value.width,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  // @override
  // Offset getPositionForChild(Size size, Size childSize) {
  //   print("my size: $size");
  //   print("childSize: $childSize");
  //   print("anchor size being passed in: $_anchorSize}");
  //   // todo: where to position the child? perform calculation here:
  //   return Offset(0, 0);
  //   // return Offset(_anchorSize.width, childSize.height / 2);
  // }


  @override
  // bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => oldDelegate is _TextSearchResultDelegate ? _anchorSize != oldDelegate._anchorSize : false ;
  // bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => oldDelegate is TextSearchResultDelegate ? _size != oldDelegate._size : false ;
  bool shouldRelayout(TextSearchResultDelegate oldDelegate) => _size != oldDelegate._size  ;

  // void _setSearchResultPanelSize(){
  //   _size.value = Size(_width,  rows==0 || rows==1 ?  50.0 : rows==2 ? 100.0 : rows==3 ? 150.0 : rows==4 ? 200.0 : 250.0 );
  // }

}


// abstract class SearchSelection {
//   String get selectedText;
// }

abstract class Searchable {
  abstract final String text, comparableText ; // displayableText
  // String get comparableText ;
}
