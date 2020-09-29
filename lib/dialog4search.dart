library dialog4search;
import 'package:flutter/material.dart';

class SearchDialog<T> extends StatefulWidget {
  //search algorithm
  final bool Function(T, String) searchFunction;
  //list in which we are going to search items;
  final List<T> list;
  final Widget Function(BuildContext, T) builder;
  final Widget Function(BuildContext, T) itemBuilder;
  final T initialValue;
  final Function(T) onInitialization;
  final Function(List<T>) onChanged;
  final InputDecoration searchBoxDecoration;
  final BoxConstraints dialogBoxConstraint;
  final WidgetBuilder noMatchBuilder;
  final Color dialogBoxBackgroundColor;
  final ShapeBorder dialogShape;
  final bool multipleSelect;
  final Widget selectionIcon;
  SearchDialog(
      {@required this.searchFunction,
        @required this.itemBuilder,
        @required this.list,
        @required this.builder,
        this.initialValue,
        this.onChanged,
        this.onInitialization,
        this.searchBoxDecoration,
        this.dialogShape,
        this.dialogBoxBackgroundColor,
        this.dialogBoxConstraint,
        this.noMatchBuilder,
        this.multipleSelect = false,
        this.selectionIcon})
      : assert(searchFunction != null),
        assert(itemBuilder != null),
        assert(builder != null),
        assert(list != null && list.length > 0);
  @override
  State<StatefulWidget> createState() {
    return _SearchDialogState<T>();
  }
}

class _SearchDialogState<T> extends State<SearchDialog<T>> {
  T _selectedItem;
  @override
  void initState() {
    _selectedItem = widget.initialValue ?? widget.list[0];
    if (widget.onInitialization != null) widget.onInitialization(_selectedItem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: widget.builder(context, _selectedItem),
        onTap: () {
          showDialog<List<T>>(
              context: context,
              builder: (context) {
                return SelectionDialog<T>(
                  itemBuilder: widget.itemBuilder,
                  list: widget.list,
                  searchFunction: widget.searchFunction,
                  searchBoxDecoration: widget.searchBoxDecoration,
                  dialogBoxBackgroundColor: widget.dialogBoxBackgroundColor,
                  dialogBoxConstraint: widget.dialogBoxConstraint,
                  dialogShape: widget.dialogShape,
                  multipleSelect: widget.multipleSelect,
                  onChanged: widget.onChanged,
                  selectionIcon: widget.selectionIcon,
                );
              }).then((value) {
            if (value != null) {
              setState(() {
                _selectedItem = value[0];
              });
              if (widget.onChanged != null) widget.onChanged(value);
            }
          });
        },
      ),
    );
  }
}

class SelectionDialog<T> extends StatefulWidget {
  final bool Function(T, String) searchFunction;
  final List<T> list;
  final Widget Function(BuildContext context, T) itemBuilder;
  final InputDecoration searchBoxDecoration;
  final BoxConstraints dialogBoxConstraint;
  final WidgetBuilder noMatchBuilder;
  final Color dialogBoxBackgroundColor;
  final ShapeBorder dialogShape;
  final bool multipleSelect;
  final Function(List<T>) onChanged;
  final Widget selectionIcon;
  SelectionDialog(
      {@required this.list,
        @required this.searchFunction,
        @required this.itemBuilder,
        this.searchBoxDecoration,
        this.dialogBoxConstraint,
        this.noMatchBuilder,
        this.dialogShape,
        this.dialogBoxBackgroundColor,
        this.multipleSelect,
        this.onChanged,
        this.selectionIcon});
  @override
  State<StatefulWidget> createState() {
    return _SelectionDialog<T>();
  }
}

class ListItem<T> {
  bool selected;
  T item;
  ListItem({this.item, this.selected});
}

class _SelectionDialog<T> extends State<SelectionDialog<T>> {
  List<ListItem<T>> _fliteredItems = [];
  List<ListItem<T>> _listItems;
  _filter(String value) {
    setState(() {
      if (value.isNotEmpty)
        _fliteredItems =_listItems.where((element) {
          return widget.searchFunction(element.item, value);
        }).toList();
      else
        _fliteredItems = _listItems;
    });
  }

  @override
  void initState() {
    _listItems = widget.list.map<ListItem<T>>((e) => ListItem(item: e,selected: false)).toList();
    _fliteredItems=_listItems;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: widget.dialogBoxBackgroundColor,
      shape: widget.dialogShape,
      titlePadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon:
              widget.multipleSelect ? Icon(Icons.check) : Icon(Icons.close),
              onPressed: () {
                if (widget.multipleSelect) {
                  var items = _fliteredItems
                      .where((element) => element.selected)
                      .toList()
                      .map<T>((e) => e.item)
                      .toList();
                  Navigator.of(context).pop(items.length > 0 ? items : null);
                } else
                  Navigator.of(context).pop(null);
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: widget.searchBoxDecoration ??
                  InputDecoration(hintText: 'Search...'),
              onChanged: (value) {
                _filter(value);
              },
            ),
          )
        ],
      ),
      children: [
        if (_fliteredItems.length > 0)
          ConstrainedBox(
            constraints: widget.dialogBoxConstraint ??
                BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  minWidth: MediaQuery.of(context).size.width - 100,
                ),
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _fliteredItems.length,
                itemBuilder: (context, index) {
                  var item = _fliteredItems[index];
                  if (widget.multipleSelect)
                    return Material(
                      color: widget.dialogBoxBackgroundColor ?? Colors.white,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: widget.itemBuilder(context, item.item)),
                              SizedBox(
                                width: 15,
                              ),
                              Opacity(
                                child: widget.selectionIcon ??
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.check,
                                          color: Theme.of(context)
                                              .primaryIconTheme
                                              .color,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                opacity: _fliteredItems[index].selected?1:0.1,
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _fliteredItems[index].selected =
                            !_fliteredItems[index].selected;
                          });
                        },
                      ),
                    );
//                      CheckboxListTile(
//                        value: _selectedItems[index].selected,
//
//                        title: widget.itemBuilder(context, item),
//                        onChanged: (value) {
//                          setState(() {
//                            _selectedItems[index].selected = value;
//                          });
//                        });
                  return SimpleDialogOption(
                    child: widget.itemBuilder(context, item.item),
                    onPressed: () {
                      _selectItem(item.item);
                    },
                  );
                },
//                children: [
//                  ..._fliteredItems
//                      .map((e){
//                        if(widget.multipleSelect){
//                          return CheckboxListTile(value: _value, onChanged: null);
//                        }else{
//                          SimpleDialogOption(
//                            child: widget.itemBuilder(context, e),
//                            onPressed: () {
//                              _selectItem(e);
//                            },
//                          )
//                        }
//                  }
//                  )
//                      .toList()
//                ],
              ),
            ),
          )
        else
          widget.noMatchBuilder == null
              ? Container(
            height: 100,
            alignment: Alignment.center,
            child: Text('No match!!'),
          )
              : widget.noMatchBuilder
      ],
    );
  }

  _selectItem(e) {
    Navigator.pop(context, <T>[e]);
  }
}
