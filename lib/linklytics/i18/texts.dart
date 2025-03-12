enum HomePageText{
  title('Linklytics Simplifies URL Shortening For Efficient Sharing.'),
  description('Linklytics streamlines the process of URL shortening, making sharing links effortless and efficient.'),
  manageLinks('Manage Links'),
  createShortLink('Create Short Link');

  const HomePageText(this.en);
  final String en;
}

enum AppBarText {
  title('Linklytics'),
  home('Home'),
  about('About'),
  signIn('SignIn');

  const AppBarText(this.en);
  final String en;
}

enum OtpLoginText {
  title('Login Here'),
  description('No account? No problem. Just enter your phone number.'),
  mobileNumber('Mobile Number'),
  otp('One Time Password (OTP)'),
  request('Request Otp'),
  submit('Submit Otp'),
  resend('Resend Otp'),
  retry('Retry in {0} seconds'),
  changeNumber('Change Phone Number?'),
  ;
  
  const OtpLoginText(this.en);
  final String en;
}

String? formatString(String message, List<String> values) {
  if (values.isEmpty || message.isEmpty) {
    return null;
  }

  return values.asMap().entries.fold(message, (prev, entry) {
    return prev?.replaceAll('{${entry.key}}', entry.value);
  });
}