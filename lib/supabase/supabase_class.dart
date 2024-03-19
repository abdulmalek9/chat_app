import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  SupabaseClient supabase = Supabase.instance.client;
  addContact(
      {required String currentUesrId,
      required String contactUserId,
      required String name}) async {
    await supabase.from('contact').insert({
      'currentUesrId': currentUesrId,
      'contactUserId': contactUserId,
      'contactName': name
    });
  }
}
