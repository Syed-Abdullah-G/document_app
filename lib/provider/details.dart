import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo/models/user_data.dart';

part 'details.g.dart';

@riverpod
class userDataNotifier extends _$userDataNotifier {
  @override
  userData build() {
    return userData(email: '', password: "", userid: '');
  }

  //method to add data during authentication




  void addData(userData userdata) {
    state = userdata;
  
  }


  Map<String, dynamic> toMap(email, password, userid) {
    return {"email": email, "password": password, "userid": userid};
  }
}
