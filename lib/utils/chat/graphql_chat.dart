import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/chat/chat_message.dart';
import 'package:leare_fa/models/chat/chat_response.dart';

class GraphQLChat {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();
  GraphQLClient client = graphQlConfig.clientToQuery();

  Future<List<ResponseChatModel>> getMyChats() async {
    String x = r'''query Chats {
      userChats{
        user_id
        user_nickname
        chat{
          id
          chat_name
          picture_id
          created_at
        }
      }
    }
  ''';
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
        ),
      );
      print(result);
      if (result.hasException) {
        throw Exception(result.exception);
      }

      List? res = result.data?['userChats'];

      if (res == null || res.isEmpty) {
        return [];
      }
      List<ResponseChatModel> chats =
          res.map((chat) => ResponseChatModel.fromMap(map: chat)).toList();

      return chats;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<MessageModel>> getMessages(String chat_id) async {
    String x = r'''
      query Messages($chat_id: ID!){
        chatMessages(chat_id:$chat_id){
          id
          chat_id
          sender_id
          sender_nickname
          content
          created_at
          updated_at
        }
      }
  ''';
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'chat_id': chat_id,
          },
        ),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }

      List? res = result.data?['chatMessages'];

      if (res == null || res.isEmpty) {
        return [];
      }
      List<MessageModel> chats =
          res.map((chat) => MessageModel.fromMap(map: chat)).toList();
      return chats;
    } catch (error) {
      throw Exception(error);
    }
  }
}
