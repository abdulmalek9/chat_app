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
        columnName: 'contactUserId, email, contactName',
        filterColumn: 'currentUesrId',
        filterValue: supabase.auth.currentUser!.id);

    if (info == null) {
      return [];
    } else {
      return info;
    }
  }

  deleteContactFromAccount(
      {required String contactId,
      required String userId,
      required bool checkboxDelete}) async {
    supabase
        .from('contact')
        .delete()
        .eq("currentUesrId", userId)
        .eq("contactUserId", contactId)
        .then((response) =>
            log("Delete all contacts from account ${response.toString()}"))
        .catchError(
            (error) => log("Error deleting all contacts from account $error"));

    if (checkboxDelete) {
      log("check box is $checkboxDelete");
      var chatId = await getChatRoomId(contactId, userId);
      supabase
          .from('messages')
          .delete()
          .eq('chat_id', chatId)
          .then((value) => log("The chat room is deleted $value"))
          .catchError((error) => log("Error in deleting $error"));
      supabase
          .from('chat_room')
          .delete()
          .eq("id", chatId)
          .then((value) => log("The chat room is deleted $value"))
          .catchError((error) => log("Error in deleting $error"));
      supabase
          .from('contact')
          .delete()
          .eq("currentUesrId", contactId)
          .eq("contactUserId", userId)
          .then((response) =>
              log("Delete all contacts from account ${response.toString()}"))
          .catchError((error) =>
              log("Error deleting all contacts from account $error"));
    }
  }

  selectFromTable(
      {required String tableName,
      String? columnName,
      String? filterColumn,
      String? filterValue}) async {
    if (columnName == null && filterColumn == null && filterValue == null) {
      return await supabase.from(tableName).select();
    } else if (filterColumn == null &&
        filterValue == null &&
        columnName != null) {
      dynamic qb = await supabase.from(tableName).select(columnName);
      return qb;
    } else if (filterColumn != null && filterValue != null) {
      dynamic qb = await supabase
          .from(tableName)
          .select(columnName!)
          .eq(filterColumn, filterValue)
          .catchError((error) => log("error is $error"));
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
    // log("id = = = = = =  = $id");

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
