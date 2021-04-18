import 'package:dio/dio.dart';
import 'package:perudo/models/json_models.dart';
import 'package:retrofit/retrofit.dart';

part 'service.g.dart';

const _baseUrl = "127.0.0.1";

@RestApi(baseUrl: "https://$_baseUrl/")
abstract class Service{
  factory Service(){
    var _dio = Dio();
    return _Service(_dio);
  }

  @GET("game-details")
  Future<GameResponse> getGameDetails();
}