//
//  Networking.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 20.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

extension ParseClient {
    
    ///Method for get Student Location with User ID, if userID = nil -> for 100 Student Locations
    func getStudentLocations(withUserID: String?, completionHandlerForGETStudentLocations: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {
        var userID: String?
        if withUserID != nil {
            userID = withUserID
        } else {
            userID = nil
        }

        _ = taskForGetStudentLocations(withUserID: userID) {(results, error) in

            if error != nil {
                completionHandlerForGETStudentLocations(nil, error)
            } else {
                if let results = results?[JSONResponseKeys.results] {
                    print(results!)
                    let studentLocations = StudentInformation.locationsFromResults(results as! [[String : AnyObject]])
                    completionHandlerForGETStudentLocations(studentLocations as AnyObject?,nil)
                } else {
                    completionHandlerForGETStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }

    ///Method for posting session to server
    func PostSession(userName: String, password: String, completionHandlerForSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        let dictionary = [JSONBodyKeys.userNameKey: userName,
                          JSONBodyKeys.passwordKey: password]
        
        _ = taskForPOSTSession(jsonBody: dictionary) {(results, error) in
            if error != nil {
                completionHandlerForSessionID(nil, error)
            } else {
                if let sessionResults = results as? [String:AnyObject] {
                    if let accounts = sessionResults[JSONResponseKeys.account] as? [String:AnyObject] {
                        if let userKey = accounts[JSONResponseKeys.key] as? String {
                            ParseClient.sharedInstance.userID = userKey
                        }
                    }
                    
                    if let session = sessionResults[JSONResponseKeys.session] as? [String:AnyObject] {
                        if let sessionID = session[JSONResponseKeys.sessionId] as? String {
                            ParseClient.sharedInstance.sessionID = sessionID
                        }
                    }
                    
                    completionHandlerForSessionID(sessionResults as AnyObject,nil)
                } else {
                    completionHandlerForSessionID(nil,NSError(domain: "getSessionID", code:1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }
    
    ///Method for posting session to server via Facebook auth
    func PostSessionFacebook(completionHandlerForFacebookSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        let dictionary = [JSONBodyKeys.facebookMobile: String(describing: FBSDKAccessToken.current())]
        
        _ = taskForPOSTSessionFacebook(jsonBody: dictionary) {(results, error) in
            if error != nil {
                completionHandlerForFacebookSessionID(nil, error)
            } else {
                if let sessionResults = results as? [String:AnyObject] {
                    if let accounts = sessionResults[JSONResponseKeys.account] as? [String:AnyObject] {
                        if let userKey = accounts[JSONResponseKeys.key] as? String {
                            ParseClient.sharedInstance.userID = userKey
                        }
                    }
                    
                    if let session = sessionResults[JSONResponseKeys.session] as? [String:AnyObject] {
                        if let sessionID = session[JSONResponseKeys.sessionId] as? String {
                            ParseClient.sharedInstance.sessionID = sessionID
                        }
                    }
                    
                    completionHandlerForFacebookSessionID(sessionResults as AnyObject, nil)
                } else {
                    completionHandlerForFacebookSessionID(nil, NSError(domain: "getSessionID", code:1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }

    ///Method for deleting session ID when logout
    func DeleteSession(completionHandlerForDeleteSession: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {

        let methodString = Methods.session

        _ = taskForDeleteSession(methodString) { (results, error) in

            if error != nil {
                completionHandlerForDeleteSession(nil, error)
            } else {
                if let results = results {
                    completionHandlerForDeleteSession(results, nil)
                } else {
                    completionHandlerForDeleteSession(nil, NSError(domain: "DeletingSession", code: 1, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse the data"]))
                }
            }
        }
    }
    
    ///Method for getting public user's data
    func GetPublicUserData() {}
}





