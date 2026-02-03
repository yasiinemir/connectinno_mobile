import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  static String from(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Bu e-posta adresi zaten kullanımda. Giriş yapmayı deneyin.';
        case 'invalid-email':
          return 'Geçersiz bir e-posta adresi girdiniz.';
        case 'operation-not-allowed':
          return 'Bu giriş yöntemi şu anda devre dışı.';
        case 'weak-password':
          return 'Şifreniz çok zayıf. Daha güçlü bir şifre belirleyin.';
        case 'user-disabled':
          return 'Bu kullanıcı hesabı engellenmiş.';
        case 'user-not-found':
          return 'Bu e-posta ile kayıtlı bir kullanıcı bulunamadı.';
        case 'wrong-password':
          return 'Girdiğiniz şifre hatalı. Lütfen tekrar deneyin.';
        case 'invalid-credential':
          return 'Giriş bilgileri hatalı veya süresi dolmuş.';
        case 'network-request-failed':
          return 'İnternet bağlantısı yok. Lütfen ağınızı kontrol edin.';
        case 'too-many-requests':
          return 'Çok fazla başarısız deneme yaptınız. Lütfen biraz bekleyin.';
        default:
          return 'Bir hata oluştu: ${e.message}';
      }
    } else {
      return 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
