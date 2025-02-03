import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<Map<String, dynamic>> likedItems = [];

  HomeBloc() : super(HomeInitialState()) {
    on<FilterByCategoryEvent>(_filterByCategory);
    on<FilterBySearchEvent>(_filterBySearch);
  }

  void _filterByCategory(FilterByCategoryEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());

    List<Map<String, dynamic>> displayedFoodItems = [];

    if (event.selectedIndex == 0) {
      displayedFoodItems = event.allFoodItems + event.allFoodItems;
    } else {
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
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is RefreshDataEvent) {
      yield HomeLoadingState(); // Show loading state
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      yield HomeLoadedState(displayedFoodItems: event.allFoodItems); // Refresh data
    }
  }

  final List<String> categories = [
    "All", "Veg", "Non-Veg", "Chinese Food", "Fast Food", "Desserts", "Beverages"
  ];
}
