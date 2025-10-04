class Perfil {
  final int? profileId;
  final String? profileName;
  final String? profileLastname;
  final String? profilePhone;
  final String? profileAddress;
  final String? profileEmail;
  final String? profilePhoto;
  final String? profileBirthdate;
  final String? profileGender;
  final String? profileNationalId;
  final String? profileBio;
  final String? profileWebsite;
  final String? profileSocial;

  Perfil({
    this.profileId,
    this.profileName,
    this.profileLastname,
    this.profilePhone,
    this.profileAddress,
    this.profileEmail,
    this.profilePhoto,
    this.profileBirthdate,
    this.profileGender,
    this.profileNationalId,
    this.profileBio,
    this.profileWebsite,
    this.profileSocial,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      profileId: json['Profile_id'],
      profileName: json['Profile_name'],
      profileLastname: json['Profile_lastname'],
      profilePhone: json['Profile_phone'],
      profileAddress: json['Profile_addres'], // Nota: typo en la API
      profileEmail: json['Profile_email'],
      profilePhoto: json['Profile_photo'],
      profileBirthdate: json['Profile_birthdate'],
      profileGender: json['Profile_gender'],
      profileNationalId: json['Profile_national_id'],
      profileBio: json['Profile_bio'],
      profileWebsite: json['Profile_website'],
      profileSocial: json['Profile_social'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Profile_name': profileName,
      'Profile_lastname': profileLastname,
      'Profile_phone': profilePhone,
      'Profile_addres': profileAddress, // Nota: typo en la API
      'Profile_email': profileEmail,
      'Profile_photo': profilePhoto,
      'Profile_birthdate': profileBirthdate,
      'Profile_gender': profileGender,
      'Profile_national_id': profileNationalId,
      'Profile_bio': profileBio,
      'Profile_website': profileWebsite,
      'Profile_social': profileSocial,
    };
  }

  String get nombreCompleto => 
    '${profileName ?? ''} ${profileLastname ?? ''}'.trim();
}