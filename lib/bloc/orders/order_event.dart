abstract class OrderEvent {}

class FetchOrdersEvent extends OrderEvent {
  final String userEmail;

  FetchOrdersEvent(this.userEmail);
}

class DeleteOrderEvent extends OrderEvent {
  final String orderId;

  DeleteOrderEvent(this.orderId);
}
