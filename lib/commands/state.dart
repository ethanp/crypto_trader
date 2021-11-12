enum MultistageCommandState {
  /// No command has been created and queued for execution.
  nonExistent,

  /// There was an error before, but it was shown to user so now it was cleared.
  resetted,

  /// Phase 0: Command was created but hasn't started. Potentially waiting for
  /// previous command to complete.
  scheduled,

  /// Phase 1: Send request to modify remote state.
  requesting,

  /// Phase 2: Double check that remote change was effected.
  verifying,

  /// Terminal phase: Double check completed and everything looks good.
  success,

  /// Look at the error itself to see what happened.
  errorDuringRequest,

  /// Look at the error itself to see what happened.
  errorDuringVerify,
}

extension abc on MultistageCommandState {
  bool get isRunning => [
        MultistageCommandState.scheduled,
        MultistageCommandState.requesting,
        MultistageCommandState.verifying,
      ].contains(this);
}
