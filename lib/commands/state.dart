enum MultistageCommandState {
  nonExistent,
  scheduled,
  requesting,
  verifying,
  success,
  errorDuringRequest,
  errorDuringVerify,
}
