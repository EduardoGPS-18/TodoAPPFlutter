class ButtonState {
  final bool isLoading;
  final bool isValid;

  ButtonState({
    required this.isLoading,
    required this.isValid,
  });

  ButtonState copyWith({bool? isLoading, bool? isValid}) {
    return ButtonState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
    );
  }
}
