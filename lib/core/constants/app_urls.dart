class AppUrls {
  static const passwordRecoveryUrl = String.fromEnvironment(
    'PASSWORD_RECOVERY_URL',
    defaultValue: 'https://control-electoral-reset.vercel.app/reset-password',
  );
}
