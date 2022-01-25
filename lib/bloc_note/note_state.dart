part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  late final Note note;
  List<Note> list = [];
  NoteLoadedState({required this.list});
}

class NoteErorState extends NoteState {}
