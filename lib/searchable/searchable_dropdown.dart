import 'package:searchable_dropdown_widget/searchable/search_result.dart';
import 'package:searchable_dropdown_widget/utils/common.dart';
import 'package:flutter/material.dart';

// class SearchableDropdown<T extends SearchSelection> extends StatefulWidget {
class SearchableDropdown<T extends Searchable> extends StatefulWidget {
  final List<T> items ;
  final TextEditingController textController ;
  // final TransitionBuilder builder ; //IndexedWidgetBuilder
  final Widget Function(T) itemBuilder ;
  final List<T> Function(String )? filter ;
  final void Function(T)? onSelect ;
  final InputDecoration? decoration;
  final Widget? searchIcon ;
  final String? label ;
  final TextStyle? textStyle;
  final bool showCloseIconOnResultPanel ;
  final bool showTrailingIcon ;
  // final VoidCallback? focusListener ;
  final void Function(bool)? onFocusChange ;
  // final VoidCallback onSearch ;
  final FormFieldValidator<T?>? validator;
  final Color? backgroundColor;
  final double? bottomPadding;
  final double? endPadding;
  final double? elevation;
  final double? borderRadius;
  final double? minHeight;
  final double? maxHeight;
  const SearchableDropdown({super.key,
    required this.items, required this.textController,
    required this.itemBuilder, this.onSelect, this.filter,
    this.decoration, this.searchIcon, this.label, this.textStyle,
    this.showCloseIconOnResultPanel=false, this.showTrailingIcon=true,
    this.onFocusChange, this.validator, this.backgroundColor,
    this.bottomPadding, this.endPadding, this.elevation, this.borderRadius,
    this.minHeight, this.maxHeight,
    // required this.onSearch,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState();

}

class _SearchableDropdownState<E extends Searchable> extends State<SearchableDropdown<E>> {
// class _SearchableDropdownState<E extends SearchSelection> extends State<SearchableDropdown<E>> {
  OverlayEntry? _overlayEntry ;
  late List<E> _filteredData ;
  final GlobalKey _searchFieldKey  = GlobalKey();
  final _layerLink = LayerLink() ;
  bool _overlayShown = false;
  final _focusNode  = FocusNode();
  final ValueNotifier<Size> _size = ValueNotifier<Size>(const Size(150, 100));
  late final Size? _searchBoxSize ;
  E? _selectedData ;

  @override
  void initState() {
    super.initState();
    _filteredData = widget.items;
    debugPrint('SearchableDropdown: initState(): _filteredData=(${_filteredData.length})$_filteredData') ;
    _focusNode.addListener(_focusListener);
    widget.textController.addListener(_textListener) ;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderObject? renderObject = _searchFieldKey.currentContext?.findRenderObject();
      if(renderObject == null ){
        return ;
      }
      final renderBox = renderObject as RenderBox ;
      _searchBoxSize = renderBox.size ;
      Log.prt('SearchableDropdown: initState(): _searchBoxSize=$_searchBoxSize -------');
      _size.value = renderBox.size;
    });
  }

  void _focusListener(){
    if(_focusNode.hasFocus){
      // _updateSearch() ;
    }else{
      _hideOverlayDetails() ;
    }
    if(widget.onFocusChange != null){
      widget.onFocusChange!(_focusNode.hasFocus) ;
    }
  }

  void _textListener(){
    if(widget.textController.text.isEmpty){
      setState(() {
        _selectedData = null ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _searchFieldKey ,
        padding: const EdgeInsets.symmetric(horizontal: 5.0,),
        decoration: BoxDecoration(
          // color: Colors.yellow,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey ), //Theme.of(context).dividerColor
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                // key: _searchFieldKey ,
                controller: widget.textController,
                focusNode: _focusNode,
                style: widget.textStyle ?? TextStyle(fontSize: 18.0),
                decoration: widget.decoration   ?? InputDecoration(
                  // hintText: '${AppLocalizations.of(context)?.searchDriver}',
                  labelText: widget.label,
                  // suffixIcon: IconButton(icon: widget.searchIcon ?? Icon(Icons.arrow_drop_down_sharp), onPressed: _onSearch) ,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (String value){
                  if(value.isEmpty){
                    _hideOverlayDetails() ;
                    return ;
                  }
                  if(widget.filter != null){
                    // setState(() => _filteredData = widget.filter!(value) ) ;
                    _filteredData = widget.filter!(value) ;
                    // _setSearchResultPanelSize(_filteredData.length) ;
                    debugPrint('SearchableDropdown: build(): TextFormField: onChange(): _filteredData=$_filteredData') ;

                    _updateSearch() ;

                  }
                },
                validator: (String? value) {
                  if(widget.validator == null){
                    return null;
                  }
                  return widget.validator!(_selectedData);

                },
              ),
            ),
            // IconButton(icon: Icon(_overlayShown ? Icons.cancel : Icons.arrow_drop_down_sharp ), onPressed: _overlayShown ? _hideOverlayDetails : _showOverlayDetails,),
            if(widget.showTrailingIcon)
            GestureDetector(
              onTap: _overlayShown ? _hideOverlayDetails : _updateSearch,
              child: Icon(_overlayShown ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp ),
            ),
          ],
        ),
      ),
    );
  }



  void _showOverlayDetails(){
    if(_searchBoxSize==null){
      return ;
    }
    _overlayEntry = OverlayEntry(builder: (BuildContext context){
      // debugPrint('--------width=${_searchBoxSize?.width} | height=${_searchBoxSize?.height}-------');
      int rows = _filteredData.length ;
      debugPrint('rows===>$rows') ;
      _setSearchResultPanelSize(rows) ;
      return CompositedTransformFollower(
        link: _layerLink,
        offset: Offset(0, _searchBoxSize!.height),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.minHeight ?? 50.0,
            maxHeight: widget.maxHeight ?? 250.0,
          ),
          child: CustomSingleChildLayout(
            delegate: TextSearchResultDelegate(
              _size,
              minHeight: widget.minHeight ?? 50.0,
              maxHeight: widget.maxHeight ?? 250.0,
            ),
            child: Material(
            elevation: widget.elevation ?? 1.0,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadius ?? 0.0),
              bottomRight: Radius.circular(widget.borderRadius ?? 0.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.borderRadius ?? 0.0),
                bottomRight: Radius.circular(widget.borderRadius ?? 0.0),
              ),
              child: Container(
                  color: widget.backgroundColor ?? Colors.white,
                  padding: EdgeInsets.only(
                    bottom: widget.bottomPadding ?? 0.0,
                    right: widget.endPadding ?? 0.0,
                  ),
                  child: Stack(
                    children: [
                      // if(_filteredData.isEmpty )
                      if( rows == 0 )
                        GestureDetector(
                          child: ListTile(title: Text('No Data Found')),
                          onTap: _hideOverlayDetails,
                        )
                      else
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const ClampingScrollPhysics(),
                        itemCount: rows, //_filteredData.length,
                    itemBuilder: (BuildContext context, int i){
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        // child: Container( child: widget.itemBuilder(_filteredData[i]),),
                        child: Container(
                          // color: Colors.green[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.itemBuilder(_filteredData[i]),
                              if(i < rows-1)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                height: 0.5, color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        // onTap: () => widget.onSelect == null ? null : widget.onSelect!(_filteredData[i]),
                        onTap: () {
                          debugPrint('widget.onSelect===>${widget.onSelect}') ;
                          widget.textController.text = _filteredData[i].text ; //comparableText ;  // selectedText ;
                          _selectedData = _filteredData[i] ;
                          if(widget.onSelect != null){
                            widget.onSelect!(_filteredData[i]) ;
                            _hideOverlayDetails();
                            _focusNode.unfocus();
                          }
                        },
                      ) ;
                    },
                        // separatorBuilder: (BuildContext context, int i)=> Container(
                        //   padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        //   height: 0.5, color: Colors.grey[400],
                        // ),
                      ),
                      if(widget.showCloseIconOnResultPanel)
                      Positioned(
                        right: 0,
                        child: IconButton(icon: Icon(Icons.cancel, size: 32, color: Colors.red,),onPressed: _hideOverlayDetails,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ) ;
    }) ;
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _overlayShown = true ;
    });
  }

  void _hideOverlayDetails([bool canSetState=true]){
    _overlayEntry?.remove();
    _overlayEntry = null ;
    if(canSetState) {
      setState(() {
        _overlayShown = false;
      });
    }
  }

  void _setSearchResultPanelSize([int? rows]){
    debugPrint('SearchableDD: _setSearchResultPanelSize(): _searchBoxSize=$_searchBoxSize') ;
    if(_searchBoxSize == null) {
      return ;
    }
    // Only set width, height will be determined by ConstrainedBox
    _size.value = Size(_searchBoxSize!.width, 0);
  }

  void _updateSearch(){
    debugPrint('_overlayShown=$_overlayShown | text on search box=${widget.textController.text}') ;
    // if(_overlayShown){
    // }
    _hideOverlayDetails();
    _showOverlayDetails() ;
  }

  @override
  void dispose() {
    widget.textController.removeListener(_textListener) ;
    _focusNode.removeListener(_focusListener) ;
    _focusNode.dispose();
    _hideOverlayDetails(false) ;
    super.dispose();
  }

}

// class DropDownEventNotifier<T> {
//   final VoidCallback expand ;
//   final Function(T) onSelect ;
//
//   DropDownEventNotifier({required this.expand, required this.onSelect});
//
// }

//// class EventController<T> extends ValueNotifier<DropDownEventNotifier<T>>{
// class EventController<T> extends ValueNotifier<T>{
//   final VoidCallback? expand ;
//   final Function(T)? select ;
//   EventController({this.expand, this.select}) : super();
//
// }
