import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/localdatabase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final DatabaseUser database;

  OrderBloc(this.database) : super(OrderInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<DeleteOrderEvent>(_onDeleteOrder);
  }

  Future<void> _onFetchOrders(
      FetchOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await database.fetchOrder(event.userEmail);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError('Error fetching orders'));
    }
  }

  Future<void> _onDeleteOrder(
      DeleteOrderEvent event, Emitter<OrderState> emit) async {
    database;
    add(FetchOrdersEvent(event.orderId)); // Fetch updated list
  }
}
