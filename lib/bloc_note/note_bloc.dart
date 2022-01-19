import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_code/models/Note.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<NoteEvent>((event, emit) {});
  }
  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is FetchNoteEvent) {
      yield NoteLoadingState();
      try {
        yield NoteLoaded(note: Note());
      } catch (e) {
        yield NoteErorState();
      }
    }
  }
}
