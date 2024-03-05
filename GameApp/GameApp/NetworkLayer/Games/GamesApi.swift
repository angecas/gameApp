//
//  GamesApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 05/02/2024.
//
 
 import Foundation

 enum GamesApi {
     case fetchListOfGames(genres: Int, freeSearch: String?, preciseSearch: Bool, tags: Int?, page: Int)
     case fetchGameTrailers(gameId: Int)
     case fetchGameYoutubeVideos(gameId: Int)
     case fetchGameTwitch(gameId: Int)
 }

 extension GamesApi: EndpointDescriptor {
     
     var page: Int? {
          switch self {
          case .fetchListOfGames(_, _, _, _, let page):
              return page
          case .fetchGameTrailers, .fetchGameYoutubeVideos, .fetchGameTwitch:
              return nil
          }
      }
     
     var pageSize: Int? {
         switch self {
         case .fetchGameTrailers, .fetchGameYoutubeVideos, .fetchGameTwitch:
             return nil
         case .fetchListOfGames(_, _, _, _, let page):
             return 9
         }
     }

     var body: Data? {
         return nil
     }
     
     var HTTPMethod: HTTPMethod {
         switch self {
         case .fetchListOfGames, .fetchGameTrailers, .fetchGameYoutubeVideos, .fetchGameTwitch:
             return .get
         }
     }
     
     var parameters: Parameters? {
         switch self {
         case .fetchListOfGames(let genres, let freeSearch, let preciseSearch, let tags, _):
             var parameters: [String: Any] = ["genres": genres as Any, "search": freeSearch, "search_precise": preciseSearch]

             if let tags = tags {
                 parameters["tags"] = tags
             }
             return parameters
         case .fetchGameTrailers(let gameId), .fetchGameYoutubeVideos(let gameId), .fetchGameTwitch(let gameId):
             return ["id": gameId]
         }
     }
     
     var path: String {
         let path = commonPath + "/games"

         switch self {
         case .fetchListOfGames(_, _, _, _, _):
             return path
         case .fetchGameTrailers(let gameId):
             return path + "/\(gameId)/movies"
         case .fetchGameYoutubeVideos(gameId: let gameId):
             return path + "/\(gameId)/youtube"
         case .fetchGameTwitch(gameId: let gameId):
             return path + "/\(gameId)/twitch"
         }
     }
 }
