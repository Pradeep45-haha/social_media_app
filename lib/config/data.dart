
//base class for data object
abstract class Data<T extends CSuccess, E extends CError> {
  final T? successData;
  final E? failureData;

  const Data({this.failureData, this.successData});
}


//error class
class CError {
  final String errorType;
  final Object errorObj;
  const CError({required this.errorType, required this.errorObj});
}

//success class
class CSuccess {
  final Object data;
  const CSuccess({required this.data});
}


//success data transfer class
class SuccessData extends Data<CSuccess, CError> {
  const SuccessData({required CSuccess successData})
      : super(successData: successData, failureData: null);
}
//failure data transfer class
class FailureData extends Data<CSuccess, CError> {
  const FailureData({required CError failureData})
      : super(successData: null, failureData: failureData);
}
