import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../../../../constants/strings.dart';
import '../../../../../utils/enums/endpoints.dart';
import '../../../presentation/states/data_state.dart';

abstract interface class IApiDataSource {
  Future<DataState<Map<String, dynamic>>> fetchMovieList(
    Endpoints chosenEndpoint,
  );
  Future<DataState<dynamic>> fetchGenresList();
}

class ApiDataSourceImpl implements IApiDataSource {
  final String _apiKey = "83251767fe0a369051de60819f1ef00f";
  Client client;

  ApiDataSourceImpl({
    required this.client,
  });

  @override
  Future<DataState<Map<String, dynamic>>> fetchMovieList(
    Endpoints chosenEndpoint,
  ) async {
    try {
      final response = await client.get(
        Uri.parse(
          "${Strings.moviesBaseUrl}${chosenEndpoint.endpointName}${Strings.apiKey}$_apiKey",
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(
          jsonDecode(
            response.body,
          ),
        );
      } else {
        return DataFailure(
          Exception(Strings.errorText),
        );
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }

  @override
  Future<DataState<dynamic>> fetchGenresList() async {
    try {
      final response = await client.get(
        Uri.parse(
          "${Strings.genresUrl}${Strings.apiKey}$_apiKey",
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(
          response.body,
        );
      } else {
        return DataFailure(
          Exception(
            Strings.errorText,
          ),
        );
      }
    } catch (e) {
      return DataFailure(
        Exception(e),
      );
    }
  }
}
