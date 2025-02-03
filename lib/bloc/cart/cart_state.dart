abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  CartLoaded(this.cartItems, this.totalAmount);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}

class OrderPlaced extends CartState {}