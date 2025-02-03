import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/localdatabase.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final DatabaseUser database;

  FavoriteBloc(this.database) : super(FavoriteInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<DeleteFavoriteEvent>(_onDeleteFavorite);
  }

  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favorites = await database.fetchFavorites(event.userEmail);
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError('Error fetching favorites'));
    }
  }

  Future<void> _onDeleteFavorite(
      DeleteFavoriteEvent event, Emitter<FavoriteState> emit) async {
    await database.deleteFavorite(event.itemName, event.userEmail);
    add(FetchFavoritesEvent(event.userEmail)); // Fetch updated list
  }
}
