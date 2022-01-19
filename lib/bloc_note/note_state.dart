part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoaded extends NoteState {
  late final Note note;
  NoteLoaded({required this.note});
}

class NoteErorState extends NoteState {}