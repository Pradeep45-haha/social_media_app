import 'package:instagram_mmvm_dp_clone/config/data.dart';


abstract class UserRepositoryAbs {
  Future<Data> getUser();
  Future<Data> createUser() ;
  Future<Data> updateUser() ;
  Future<Data> removeUser() ;
}




