import 'package:flutter_bloc/flutter_bloc.dart';
 
class SearchBarCubit extends Cubit<bool> {
  SearchBarCubit() : super(false);
 
  void onTextChanged(String text) => emit(text.isNotEmpty);
 
  void clear() => emit(false);
}
 