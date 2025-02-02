import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // In-memory list to track liked items.
  List<Map<String, dynamic>> likedItems = [];

  HomeBloc() : super(HomeInitialState()) {
    on<FilterByCategoryEvent>(_filterByCategory);
    on<FilterBySearchEvent>(_filterBySearch);
  }

  void _filterByCategory(FilterByCategoryEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());

    List<Map<String, dynamic>> displayedFoodItems = [];

    if (event.selectedIndex == 0) {
      // Show all items (duplicated)
      displayedFoodItems = event.allFoodItems + event.allFoodItems;
    } else {
      // Filter by category
      String category = categories[event.selectedIndex];
      var filteredItems = event.allFoodItems
          .where((item) => item['category'] == category)
          .toList();
      displayedFoodItems = filteredItems + filteredItems;
    }

    emit(HomeLoadedState(
      displayedFoodItems: displayedFoodItems,
    ));
  }

  void _filterBySearch(FilterBySearchEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());

    List<Map<String, dynamic>> displayedFoodItems = [];

    if (event.query.isEmpty) {
      displayedFoodItems = event.allFoodItems + event.allFoodItems;
    } else {
      displayedFoodItems = event.allFoodItems.where((item) {
        return item['name']
            .toLowerCase()
            .contains(event.query.toLowerCase()) ||
            item['category']
                .toLowerCase()
                .contains(event.query.toLowerCase());
      }).toList();
    }

    emit(HomeLoadedState(
      displayedFoodItems: displayedFoodItems,
    ));
  }


  // Static categories list
  final List<String> categories = [
    "All", "Veg", "Non-Veg", "Chinese Food", "Fast Food", "Desserts", "Beverages"
  ];
}
