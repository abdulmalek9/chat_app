class ContactModel {
  final String? name;
  final String? lastmessage;
  final String? email;
  final String? contactId;

  ContactModel(
      {required this.email,
      required this.name,
      this.contactId,
      this.lastmessage});
}
