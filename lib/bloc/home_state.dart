part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class LoadedImage extends HomeState {
  final File image;

  LoadedImage({@required this.image});
  @override
  List<Object> get props => [image];
}

class AuthenticationDone extends HomeState {
  @override
  List<Object> get props => [];
}

class AuthenticationFailure extends HomeState {
  final String message;

  AuthenticationFailure({@required this.message});
  @override
  List<Object> get props => [message];
}
