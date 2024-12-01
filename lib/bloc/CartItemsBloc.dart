// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/helpers/dbHelper.dart';
import 'package:pos_app/models/tbl_dk_cart_item.dart';
import 'package:pos_app/models/tbl_mg_mat_attributes.dart';
import 'package:pos_app/models/v_dk_resource.dart';
import 'package:pos_app/provider/GlobalVarsProvider.dart';
import 'package:pos_app/models/tbl_dk_user.dart';

//region /////////////// EVENTS /////////////
class CartItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeCartItemCount extends CartItemEvent {
  final VDkResource _resource;
  final int rpAccId;
  final double _itemCount;
  final bool _decreasing;
  final List<TblMgMatAttributes> matAttrs;
  final int tableId;

  ChangeCartItemCount(this._resource, this._itemCount, this._decreasing, this.rpAccId, this.matAttrs, this.tableId);

  @override
  List<Object> get props => [_resource, _itemCount, rpAccId, _decreasing, matAttrs, tableId];

  @override
  String toString() => "Changed cart item count of resource by id $_resource.ResId to $_itemCount";
}

class LoadTblDkCartItems extends CartItemEvent {
  final List<TblDkCartItem> providerTblDkCartItems;
  final TblDkUser tblUser;

  LoadTblDkCartItems(this.providerTblDkCartItems, this.tblUser);

  @override
  List<Object> get props => [providerTblDkCartItems, tblUser];

  @override
  String toString() => "LoadTblDkCartItems event";
}

//endregion /////////////// EVENTS /////////////

//region ///////////States///////////////////
class CartItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartItemIsntSelected extends CartItemState {
  @override
  String toString() => "TblDkCartItemIsntSelected state";
}

class CartItemCountChanged extends CartItemState {
  final double _itemCount;
  final VDkResource _resource;
  final List<TblDkCartItem> _cartItems;
  final bool _exceeded;

  CartItemCountChanged(this._itemCount, this._resource, this._cartItems, this._exceeded);

  double get getItemCount => _itemCount;

  VDkResource get getResource => _resource;

  List<TblDkCartItem> get getCartItems => _cartItems;

  bool get isExceeded => _exceeded;

  @override
  List<Object> get props => [_itemCount, _resource, _cartItems, _exceeded];

  @override
  String toString() => "CartItemCountChanged state";
}

class CartItemLoading extends CartItemState {
  @override
  String toString() => "CartItemLoading state";
}

class CartItemLoaded extends CartItemState {
  final List<TblDkCartItem> _cartItems;

  CartItemLoaded(this._cartItems);

  List<TblDkCartItem> get getCartItems => _cartItems;

  @override
  String toString() => "TblDkCartItemLoaded state";

  @override
  List<Object> get props => [_cartItems];
}

class CartItemLoadError extends CartItemState {
  @override
  String toString() => "TblDkCartItemLoadError state";
}

//endregion ///////////States///////////////////

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  List<TblDkCartItem> _cartItems = [];
  final GlobalVarsProvider globalProvider;

  CartItemBloc(this.globalProvider) : super(CartItemIsntSelected()){
    on<ChangeCartItemCount>(_mapTblDkCartItemCountChangedToState);
    on<LoadTblDkCartItems>(_mapLoadTblDkCartItemsToState);
  }

  @override
  void onTransition(Transition<CartItemEvent, CartItemState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }


  void _mapTblDkCartItemCountChangedToState(ChangeCartItemCount event, Emitter<CartItemState> emit) async {
    List<TblDkCartItem> items = [];
    _cartItems = globalProvider.getCartItems;
    items = _cartItems.where((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId)).toList();

    if ((items.isEmpty) && (event._itemCount > 0)) {
      TblDkCartItem cartItem = TblDkCartItem(
          ItemCount: event._itemCount.toInt(),
          ResId: event._resource.ResId,
          ItemPriceTotal: ((event._itemCount * event._resource.SalePrice)),
          matAttributes: event.matAttrs,
          TableId: event.tableId,
          ResName: event._resource.ResName,
          ResNameTm: event._resource.ResNameTm,
          ResNameRu: event._resource.ResNameRu,
          ResNameEn: event._resource.ResNameEn,
          ResPriceGroupId: 0,
          ResPriceValue: event._resource.SalePrice,
          SyncDateTime: event._resource.SyncDateTime,
          RpAccId: 0,
          ImageFilePath: event._resource.ImageFilePath);
      _cartItems.add(cartItem);
      debugPrint("Print try insert TblDkCartItem to db");
      DbHelper.insertCartItem('tbl_dk_cart_item', cartItem, event._resource.ResId, event.tableId);
    }
    else {
      if (event._itemCount == 0) {
        _cartItems.removeWhere((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId));
        debugPrint("Print try delete TblDkCartItem to db");
        DbHelper.deleteCartItem(event._resource.ResId, event.tableId);
      }
      else if (items.isNotEmpty) {
        _cartItems
            .where((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId))
            .first
            .ItemCount = event._itemCount.toInt();
          _cartItems
              .where((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId))
              .first
              .ItemPriceTotal =
              _cartItems
                  .where((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId))
                  .first
                  .ItemCount *
                  _cartItems
                      .where((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId))
                      .first
                      .ResPriceValue;
        debugPrint("Print try insert TblDkCartItem to db");
        DbHelper.insertCartItem('tbl_dk_cart_item', _cartItems
            .where((item) => (item.ResId == event._resource.ResId && item.TableId==event.tableId))
            .first, event._resource.ResId, event.tableId);
      }
    }
      emit(CartItemCountChanged(event._itemCount, event._resource, _cartItems, true));
    _cartItems.removeWhere((item) => item.ItemCount <= 0);
  }

  void _mapLoadTblDkCartItemsToState(LoadTblDkCartItems event, Emitter<CartItemState> emit) async {
    emit(CartItemLoading());
    try {
      if (event.providerTblDkCartItems.isNotEmpty) {
        for (int i = 0; i < event.providerTblDkCartItems.length; i++) {
              event.providerTblDkCartItems.removeWhere((element) => element.ResId == event.providerTblDkCartItems[i].ResId);
        }
      }
      emit(CartItemLoaded(event.providerTblDkCartItems));
    } catch (_) {
      emit(CartItemLoadError());
    }
  }
}
