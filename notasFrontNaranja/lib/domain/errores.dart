enum AppError {
  NotFound,
  EmpyOrNullTag
}

class MyError {
  final AppError key;
  final String? message;

  const MyError({
    required this.key, 
    this.message,
  });
}