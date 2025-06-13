import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../requests/nasa_api.dart';
import '../models/photo.dart';

part 'nasa_state.dart';

class NasaCubit extends Cubit<NasaState> {
  final NasaApi _api;

  NasaCubit(this._api) : super(NasaInitial());

  void fetchPhotos() async {
    emit(NasaLoading());
    try {
      final photos = await _api.fetchPhotos();
      emit(NasaLoaded(photos));
    } catch (e) {
      emit(NasaError(e.toString()));
    }
  }
}
