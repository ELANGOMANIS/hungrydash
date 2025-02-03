abstract class CartEvent {}

class FetchCartEvent extends CartEvent {
  final String userEmail;

  FetchCartEvent(this.userEmail);
}

class DeleteCartEvent extends CartEvent {
  final String name;
  final String userEmail;

  DeleteCartEvent(this.name, this.userEmail);
}

class PlaceOrderEvent extends CartEvent {
  final String userEmail;
  final String area;
  final String city;
  final String district;

  PlaceOrderEvent(this.userEmail, this.area, this.city, this.district);
}