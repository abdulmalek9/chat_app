import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  SupabaseClient supabase = Supabase.instance.client;

  addContact(
      {required String currentUesrId,
      required String contactUserId,
      required String name,
      required String email}) async {
    await supabase.from('contact').insert({
      'currentUesrId': currentUesrId,
      'contactUserId': contactUserId,
      'contactName': name,
      'email': email,
    });
  }

  getContact() async {
    List<Map<String, dynamic>>? info = await SupabaseServices().selectFromTable(
        tableName: "contact",
        rowName: 'contactUserId, email, contactName',
        filterColumn: 'currentUesrId',
        filterValue: supabase.auth.currentUser!.id);
    if (info == null) {
      return [];
    } else {
      return info;
    }
  }

  selectFromTable(
      {required String tableName,
      String? rowName,
      String? filterColumn,
      String? filterValue}) async {
    if (rowName == null && filterColumn == null && filterValue == null) {
      return await supabase.from(tableName).select();
    } else if (filterColumn == null && filterValue == null && rowName != null) {
      dynamic qb = await supabase.from(tableName).select(rowName);
      return qb;
    } else if (filterColumn != null && filterValue != null) {
      dynamic qb = await supabase
          .from(tableName)
          .select(rowName!)
          .eq(filterColumn, filterValue);
      return qb;
    }
  }

  Future<bool> cheackIfExist(String email) async {
    try {
      final response =
          await supabase.from('profiles').select('id').eq('email', email);

      if (response.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }

    // print("object======================== $response");
  }

  addChatRoom({required String memb1, required String memb2}) async {
    var id = await selectFromTable(tableName: 'chat_room');
    log("id = = = = = =  = $id");

    if (!id.isEmpty) {
      final r = await cheakIfChatRoomExist(id: id, memb1: memb1, memb2: memb2);
      print('r===$r');
      if (!r) {
        await supabase
            .from('chat_room')
            .insert({"first_member": memb1, "second_member": memb2});
      }
    } else {
      print("out if adding first chat");
      await supabase
          .from('chat_room')
          .insert({"first_member": memb1, "second_member": memb2});
    }
  }
  //  log(((id[v]['first_member'] != memb1 &&
  //                 id[v]['first_member'] != memb2) ||
  //             (id[v]['second_member'] != memb1 &&
  //                 id[v]['second_member'] != memb2))
  //         .toString());

  cheakIfChatRoomExist(
      {required dynamic id,
      required String memb1,
      required String memb2}) async {
    for (var v = 0; v < id.length; v++) {
      if (((id[v]['first_member'] != memb1 && id[v]['first_member'] != memb2) ||
          (id[v]['second_member'] != memb1 &&
              id[v]['second_member'] != memb2))) {
        continue;
      } else {
        return true;
      }
    }
    return false;
  }

  getChatRoomId(String contactId, String currentUesrId) async {
    List<Map<String, dynamic>> chatRoomTable =
        await supabase.from('chat_room').select();
    for (int v = 0; v < chatRoomTable.length; v++) {
      if (!((chatRoomTable[v]['first_member'] != contactId &&
              chatRoomTable[v]['first_member'] != currentUesrId) ||
          (chatRoomTable[v]['second_member'] != contactId &&
              chatRoomTable[v]['second_member'] != currentUesrId))) {
        return chatRoomTable[v]['id'];
      }
    }
    return 'not found';
  }
}
