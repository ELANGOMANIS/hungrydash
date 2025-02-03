part of 'home_bloc.dart';

abstract class HomeEvent {}

class FilterByCategoryEvent extends HomeEvent {
  final int selectedIndex;
  final List<Map<String, dynamic>> allFoodItems;

  FilterByCategoryEvent({required this.selectedIndex, required this.allFoodItems});
}

class FilterBySearchEvent extends HomeEvent {
  final String query;
  final List<Map<String, dynamic>> allFoodItems;

  FilterBySearchEvent({required this.query, required this.allFoodItems});
}

class ToggleLikeEvent extends HomeEvent {
  final String userEmail;
  final Map<String, dynamic> foodItem;

  ToggleLikeEvent({required this.userEmail, required this.foodItem});
}

class FetchLikedItemsEvent extends HomeEvent {
  final String userEmail;

  FetchLikedItemsEvent({required this.userEmail});
}
class RefreshDataEvent extends HomeEvent {
  final List<Map<String, dynamic>> allFoodItems;

  RefreshDataEvent({required this.allFoodItems});
}
class AddFavoriteEvent extends HomeEvent {
  final String email;
  final int foodItemId;
  final String name;
  final String profilePic;

  AddFavoriteEvent({
    required this.email,
    required this.foodItemId,
    required this.name,
    required this.profilePic,
  });
}
