import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/localdatabase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<FetchCartEvent>(_onFetchCart);
    on<DeleteCartEvent>(_onDeleteCart);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      List<Map<String, dynamic>> cartItems = await DatabaseUser().fetchCart(event.userEmail);
      double totalAmount = _calculateTotalAmount(cartItems);
      emit(CartLoaded(cartItems, totalAmount));
    } catch (e) {
      emit(CartError('Error fetching cart items'));
    }
  }

  Future<void> _onDeleteCart(DeleteCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await DatabaseUser().deleteCart(event.name, event.userEmail);
      List<Map<String, dynamic>> cartItems = await DatabaseUser().fetchCart(event.userEmail);
      double totalAmount = _calculateTotalAmount(cartItems);
      emit(CartLoaded(cartItems, totalAmount));
    } catch (e) {
      emit(CartError('Error deleting cart item'));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartItems = await DatabaseUser().fetchCart(event.userEmail);
      double totalAmount = 0.0;

      for (var item in cartItems) {
        await DatabaseUser().insertOrder(
          item,
          event.userEmail,
          event.area,
          event.city,
          event.district,
          totalAmount,
        );
        totalAmount += item['price'];
      }

      await DatabaseUser().clearCart(event.userEmail);
      emit(OrderPlaced());
    } catch (e) {
      emit(CartError('Error placing order'));
    }
  }

  double _calculateTotalAmount(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] as double));
  }
}
