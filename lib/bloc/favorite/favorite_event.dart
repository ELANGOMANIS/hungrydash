import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFavoritesEvent extends FavoriteEvent {
  final String userEmail;

  FetchFavoritesEvent(this.userEmail);

  @override
  List<Object> get props => [userEmail];
}

class DeleteFavoriteEvent extends FavoriteEvent {
  final String itemName;
  final String userEmail;

  DeleteFavoriteEvent(this.itemName, this.userEmail);

  @override
  List<Object> get props => [itemName, userEmail];
}
