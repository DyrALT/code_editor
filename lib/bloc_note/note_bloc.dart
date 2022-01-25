import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_code/models/Note.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  Note not = Note();
  NoteBloc() : super(NoteInitial()) {
    on<NoteEvent>((event, emit) async* {
      if (event is FetchNoteEvent) {
        print("EVENT GİRDİ");
        yield NoteLoadingState();
        try {
        print("LOADED STATE ÇALIŞIYOR");
          List<Note> list = await not.getNotes();
          yield NoteLoadedState(list: list);
        } catch (e) {
          yield NoteErorState();
        }
      }
    });
  }
}
