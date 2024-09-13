import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/firestore_repository.dart';
import 'firestore_event.dart';
import 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreRepository _firestoreRepository;

  FirestoreBloc(this._firestoreRepository) : super(FirestoreInitial());

  @override
  Stream<FirestoreState> mapEventToState(FirestoreEvent event) async* {
    if (event is SendMessageEvent) {
      yield FirestoreLoading();
      try {
        await _firestoreRepository.sendMessage(
          event.messageText,
          event.senderEmail,
          event.receiverEmail,
        );
        yield FirestoreMessageSent();
      } catch (e) {
        yield FirestoreError(message: e.toString());
      }
    } else if (event is GetMessagesEvent) {
      yield FirestoreLoading();
      try {
        final messagesStream = _firestoreRepository.getMessagesStream(
          event.currentUserEmail,
          event.otherUserEmail,
        );
        yield* messagesStream.map((snapshot) {
          return FirestoreMessagesLoaded(
            messages: snapshot.docs,
          );
        });
      } catch (e) {
        yield FirestoreError(message: e.toString());
      }
    } else if (event is SendOTPEvent) {
      yield FirestoreLoading();
      try {
        await _firestoreRepository.sendOTP(
          phoneNumber: event.phoneNumber,
          onCodeSent: (verificationId) {},
          onVerificationFailed: (error) {
            add(FirestoreError(message: error.message ?? 'Verification failed')
                as FirestoreEvent);
          },
        );
      } catch (e) {
        yield FirestoreError(message: e.toString());
      }
    } else if (event is VerifyOTPEvent) {
      yield FirestoreLoading();
      try {
        final result = await _firestoreRepository.verifyOTP(
          verificationId: event.verificationId,
          smsCode: event.smsCode,
        );
        if (result) {
          yield FirestoreOTPVerified();
        } else {
          yield FirestoreOTPFailed();
        }
      } catch (e) {
        yield FirestoreError(message: e.toString());
      }
    } else if (event is GetUsersEvent) {
      yield FirestoreLoading();
      try {
        final users = await _firestoreRepository.getUsers();
        yield FirestoreUsersLoaded(users: users);
      } catch (e) {
        yield FirestoreError(message: e.toString());
      }
    }
  }
}
