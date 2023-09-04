import 'package:graphql/client.dart';

import 'Constants.dart';

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    Constants.BASEURL,
    defaultHeaders: {Constants.HEADER_API_KEY: Constants.API_KEY},
  );

  static final GraphQLClient tempClient = GraphQLClient(
    cache: GraphQLCache(),
    link: _httpLink,
  );
}