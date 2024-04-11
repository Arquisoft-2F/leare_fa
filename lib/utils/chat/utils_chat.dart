import 'package:leare_fa/models/chat/chat_response.dart';

String getImageLetters(ChatModel chat) {
  String letters = "";
  final splitted = chat.name.split(' ');
  for (String word in splitted) {
    letters += word[0].toUpperCase();
  }
  return letters;
}

String convertDate(DateTime? x) {
  String res = "";
  if (x?.year != null) {
    res += x!.year.toString();
    res += "-";
  }
  if (x?.month != null) {
    res += x!.month.toString();
    res += "-";
  }
  if (x?.day != null) {
    res += x!.day.toString();
    res += "-";
  }
  return res.substring(0, res.length - 1);
}

String getDate(ChatModel chat) {
  if (chat.last_message?.update != null) {
    return convertDate(chat.last_message!.update);
  } else if (chat.creation != null) {
    return convertDate(chat.creation);
  }
  return "";
}
