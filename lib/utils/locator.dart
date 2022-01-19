import 'package:get_it/get_it.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator()async {
  locator.registerLazySingleton(() => TemaBloc());
}
