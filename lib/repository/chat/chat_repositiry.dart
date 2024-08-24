import 'package:instagram_mmvm_dp_clone/config/data.dart';

abstract class ChatRepositoryAbs {
  Future<Data> getChats();
  Future<Data> sendChat();
  Future<Data> removeChat();
  
}
