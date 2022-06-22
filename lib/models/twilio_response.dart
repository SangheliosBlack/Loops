// To parse this JSON data, do
//
//     final twilioResponse = twilioResponseFromJson(jsonString);

import 'dart:convert';

TwilioResponse twilioResponseFromJson(String str) =>
    TwilioResponse.fromJson(json.decode(str));


class TwilioResponse {
  TwilioResponse(
      {required this.sid,
      required this.serviceSid,
      required this.accountSid,
      required this.to,
      required this.channel,
      required this.status,
      required this.payee,
      required this.amount,
      required this.valid,
      required this.dateCreated,
      required this.dateUpdated});

  String sid;
  String serviceSid;
  String accountSid;
  String to;
  String channel;
  String status;
  dynamic payee;
  dynamic amount;
  bool valid;
  DateTime dateCreated;
  DateTime dateUpdated;

  factory TwilioResponse.fromJson(Map<String, dynamic> json) => TwilioResponse(
        sid: json["sid"],
        serviceSid: json["serviceSid"],
        accountSid: json["accountSid"],
        to: json["to"],
        channel: json["channel"],
        status: json["status"],
        payee: json["payee"],
        amount: json["amount"],
        valid: json["valid"],
        dateCreated: DateTime.parse(json['dateCreated']),
        dateUpdated: DateTime.parse(json['dateUpdated']),
      );

  
}
