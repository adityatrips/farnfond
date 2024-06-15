import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final Timestamp birthdate;
  final Timestamp anniversary;
  final String email;
  final String key;
  final String name;
  final String partnerCode;

  AppUser({
    required this.birthdate,
    required this.anniversary,
    required this.email,
    required this.key,
    required this.name,
    required this.partnerCode,
  });
}
