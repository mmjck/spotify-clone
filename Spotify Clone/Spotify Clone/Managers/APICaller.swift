//
//  APICaller.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import Foundation


struct EndPoints {
    static let baseURLAPI = "https://api.spotify.com/v1"
}


final class APICaller {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    
    enum APIError: Error {
        case failedToGetData
    }
    
    
    static let shared = APICaller()
    
    
    private init(){
        
    }
    
    // MARK: - Category
    public func getCategory(completion: @escaping (Result<[Category], Error>) -> Void ){
        createRequest(with: URL(string: "\(EndPoints.baseURLAPI)/browse/categories?limit=2" ), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                     let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                     print(json)
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    print(result.categories.items)
                    completion(.success(result.categories.items))
                    
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistCategory(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void ){
        createRequest(with: URL(string: "\(EndPoints.baseURLAPI)/browse/categories/\(category.id)/playlists?limit=2" ), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                     //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                     //print(json)
                    
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    //print(result.playlists.items)
                    completion(.success(result.playlists.items))
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    // MARK: - Playlist
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void ){
        createRequest(with: URL(string: "\(EndPoints.baseURLAPI)/playlists/\(playlist.id)" ), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                    //                    print(result)
                }catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - Albums
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void ){
        createRequest(with: URL(string: "\(EndPoints.baseURLAPI)/albums/\(album.id)" ), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                    //                    print(result)
                }catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void ){
        createRequest(with: URL(string: EndPoints.baseURLAPI + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    //                     let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //                     print(json)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    //                    print(result)
                }catch {
                    completion(.failure(error))
                }
                
            }
            
            
            task.resume()
            
        }
        
    }
    
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void ){
        createRequest(with: URL(string: "\(EndPoints.baseURLAPI)/browse/new-releases?limit=10"), type: .GET){
            request in
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(json)
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationResponse, Error>)) -> Void ){
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: URL(string: "\(EndPoints.baseURLAPI)/recommendations?limit=10&seed_genres=\(seeds)"),
            type: .GET
        ){
            request in
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                    completion(.success(result))
                }catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>)) -> Void ){
        createRequest(
            with: URL(string: "\(EndPoints.baseURLAPI)/recommendations/available-genre-seeds"),
            type: .GET
        ){
            request in
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(json)
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                }catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    public func getFlayPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>)) -> Void ){
        createRequest(with: URL(string: "\(EndPoints.baseURLAPI)/browse/featured-playlists?limit=10"), type: .GET){
            request in
            let task = URLSession.shared.dataTask(with: request){
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(json)
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                }catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    }
    
    
    
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void ){
            AuthManager.shared.withValidToken {
                token in
                guard let apiUrl = url else { return }
                
                var request = URLRequest(url: apiUrl)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = type.rawValue
                request.timeoutInterval = 30
                completion(request)
            }
        }
    
}


