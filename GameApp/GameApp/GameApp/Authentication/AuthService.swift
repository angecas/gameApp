//
//  AuthApi.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 06/02/2024.
//

import Foundation
import FirebaseAuth

struct AuthService {
//    static let shared
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    func logout(completion: @escaping (Error?) -> Void) {
        do {
               try Auth.auth().signOut()
               completion(nil)
           } catch let error as NSError {
               print(error.localizedDescription)
               completion(error)
           }    }
}
