import 'package:flutter/material.dart';
import 'package:searchable_dropdown_widget/searchable/search_result.dart';

enum SearchResultView {list, grid}

class SearchableTextFormField<T extends Searchable> extends StatefulWidget {
// class SearchableTextFormField<T extends SearchSelection> extends StatefulWidget {
  final void Function(String)? onChanged ;
  // final List<T> items ;
  final Widget? Function(T) itemBuilder;
  final Function(T)? onSelect;
  final TextEditingController controller ;
  // final FocusNode? focusNode ;
  // final Widget? Function(BuildContext, int) detailItemBuilder;
  final List<T> Function(String)? searchFilter ;
  final Future<List<T>?> Function(String)? search ;
  final InputDecoration? decoration ;
  final SearchResultView resultView ;
  // final Future<List<T>> Function()? load ;
  final String? Function(String?)? validator;
  final String? hintText ;
  final Color? backgroundColor;
  final double? bottomPadding;
  final double? endPadding;
  final double? elevation;
  final double? borderRadius;
  final double? minHeight;
  final double? maxHeight;

  const SearchableTextFormField({
    super.key,
    required this.controller, //this.focusNode,
    // required this.items,
    required this.itemBuilder, this.onSelect,
    this.onChanged, this.searchFilter, this.search, this.decoration, this.resultView=SearchResultView.list,
    this.validator,
    this.hintText,
    this.backgroundColor,
    this.bottomPadding, this.endPadding, this.elevation, this.borderRadius,
    this.minHeight, this.maxHeight,
  }) ;

  @override
  State<SearchableTextFormField<T>> createState() => _SearchableTextFormFieldState<T>();
}

class _SearchableTextFormFieldState<T extends Searchable> extends State<SearchableTextFormField<T>> {
// class _SearchableTextFormFieldState<T extends SearchSelection> extends State<SearchableTextFormField<T>> {
  // final _searchController  = TextEditingController();
  final _layerLink = LayerLink();
  final _focusNode = FocusNode();
  // late OverlayState _overlayState ;
  OverlayEntry? _overlayEntry ;
  List<T>? _filteredData ;
  final GlobalKey _searchFieldKey  = GlobalKey();
  late final ValueNotifier<Size> _size ; // = ValueNotifier<Size>(const Size(200.0, 100.0));

  @override
  void initState() {
    super.initState();
    // _searchController = widget.controller ?? TextEditingController() ;
    // _overlayState = Overlay.of(context);
    // _searchFieldKey = widget.key ??  GlobalKey() ;
    // _filteredData = widget.items ;
    // _overlayEntry = OverlayEntry(builder: (context){
    //   return ListView.builder(itemBuilder: widget.detailItemBuilder) ;
    // }) ;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _showOverlayDetails();
    // }) ;
    // _focusNode.addListener(() => _focusNode.hasFocus ? _showOverlayDetails());
    // _focusNode.addListener(_focusNode.hasFocus ? _showOverlayDetails : _hideOverlayDetails);
    _focusNode.addListener(_focusNode.hasFocus ? _updateSearch : _hideOverlayDetails);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox = _searchFieldKey.currentContext!.findRenderObject() as RenderBox;
      debugPrint('--------initState(): width=${renderBox.size.width} | height=${renderBox.size.height}-------');
      _size = ValueNotifier<Size>(renderBox.size);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          // key: widget.key,
          focusNode: _focusNode, // widget.focusNode ?? _focusNode,
          key: _searchFieldKey,
          controller: widget.controller, // ?? _searchController, //
          onChanged: (String value) {
            if(widget.onChanged != null) {
              widget.onChanged!(value);
            }
            if(value.isEmpty){
              _hideOverlayDetails();
            }
            },
          style: TextStyle(fontSize: 18.0),
          decoration: widget.decoration ?? InputDecoration(
            hintText: widget.hintText ?? 'Search',
            suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () async {
              if (widget.search != null ) {
                _filteredData = await widget.search!(widget.controller.text); // _searchController
                // _showOverlayDetails();
                _updateSearch();
              }
            },),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.0)
            ),
            contentPadding: EdgeInsets.all(5.0)
          ),
          validator: widget.validator,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    _focusNode.dispose();
    // _searchController.dispose();
    super.dispose();
  }

  void _showOverlayDetails(){
    debugPrint('_showOverlayDetails(): data=${_filteredData}') ;
    if(_filteredData == null){
      return ;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final renderBoxOuter = context.findRenderObject() as RenderBox;
      final renderBox = _searchFieldKey.currentContext!.findRenderObject() as RenderBox;
      // final offset = renderBox.localToGlobal(Offset.zero) ;
      // final size = renderBox.size ;
      // final size = Size(renderBox.size.width, (_filteredData?.isEmpty ?? true) ? 72 :  _filteredData!.length < 4 ? 90 : renderBox.size.height);
      // _size.value = renderBox.size ;
      _size.value = Size(renderBox.size.width, _changeHeight(_filteredData?.length) );
      _overlayEntry = OverlayEntry(
        builder: (context) {
          // debugPrint('--------Outer : width=${renderBoxOuter.size.width} | height=${renderBoxOuter.size.height}-------');
          debugPrint('--------width=${renderBox.size.width} | height=${renderBox.size.height}-------');

          debugPrint('--------After resize condition: width=${_size.value.width} | height=${_size.value.height}-------');
          return CompositedTransformFollower(
            link: _layerLink,
            // showWhenUnlinked: false,
            offset: Offset(0, renderBox.size.height),
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
                    // width: size.width,
                    child: Stack(
                      // clipBehavior: Clip.none,
                      children: [
                    if(_filteredData?.isEmpty ?? true)
                      GestureDetector(
                        child: ListTile(title: Text('No Data Found')),
                        onTap: _hideOverlayDetails,
                      )
                    else
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      // clipBehavior: Clip.none,
                      itemCount: _filteredData?.length ?? 0 , //widget.items.length,
                      itemBuilder: (BuildContext context, int i) => GestureDetector(
                        child: Container(child: widget.itemBuilder(_filteredData![i])),
                        onTap: () {
                          widget.controller.text = _filteredData![i].comparableText ; // selectedText ;
                          if(widget.onSelect != null){
                            widget.onSelect!(_filteredData![i]) ;
                            // _searchController.text = _filteredData![i].selectedText ;
                            _hideOverlayDetails();
                            _focusNode.unfocus();
                          }
                        },
                      ),
                    ),
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
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry!);
      // _overlayState.insert(_overlayEntry!);
    });
  }

  void _hideOverlayDetails(){
    debugPrint('hiding overlays...........');
    _overlayEntry?.remove();
    _overlayEntry = null ;
    Overlay.of(context).setState(() {

    });
    debugPrint('hidden *********');
  }

  void _updateSearch(){
    debugPrint('SearchableTextFormField: _updateSearch(): text on search box=${widget.controller.text}') ;
    // if(_overlayShown){
    // }
    _hideOverlayDetails();
    _showOverlayDetails() ;
  }

  double _changeHeight(int? records){
    if(records == null || records==0){
      return 50.0 ;
    }
    return records==1 ?  50.0 : records==2 ? 100.0 : records==3 ? 150.0 : records==4 ? 200.0 : 250.0 ;
  }
}


