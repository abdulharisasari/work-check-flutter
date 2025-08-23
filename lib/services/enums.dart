enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch,
}

enum BaseURL {
  NPM,
  CUSTOM,
  GMAPS,
}

enum GrantType {
  PASSWORD,
  FIREBASE,
  PHONE,
  OTP,
}

enum PasswordStrength {
  Weak,
  Medium,
  Strong,
}

enum ServerEnvironment {PRODUCTION, DEVELOPMENT }