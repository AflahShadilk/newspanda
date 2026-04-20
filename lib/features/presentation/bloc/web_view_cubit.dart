import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//State 
class WebViewState extends Equatable {
  final int progress;
  final bool isLoading;

  const WebViewState({
    this.progress = 0,
    this.isLoading = true,
  });

  WebViewState copyWith({int? progress, bool? isLoading}) => WebViewState(
        progress: progress ?? this.progress,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object> get props => [progress, isLoading];
}

//Cubit 
class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(const WebViewState());

  void onProgress(int progress) =>
      emit(state.copyWith(progress: progress));

  void onPageStarted() =>
      emit(state.copyWith(isLoading: true, progress: 0));

  void onPageFinished() =>
      emit(state.copyWith(isLoading: false, progress: 100));
 
  void onPageError() =>
      emit(state.copyWith(isLoading: false));
}