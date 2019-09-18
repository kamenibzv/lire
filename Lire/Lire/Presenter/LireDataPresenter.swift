//
//  LireDataPresenter.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/5/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import Foundation
import Alamofire

protocol DataPresenterProtocol {
    // Protocol used to update the view
    func emptryStringDetected()
    func clearBackgroundLabel()
    func resultsWithData(data: [Books])
    func stopViewAnimation()
    func resultIsEmpty(forText: String)
    func errorSearching(_ string: String)
}

class LireDataPresenter {
    /*
     Responsible for making data calls and acting as the presenter to send the data back to the view using protocols
     */
    
    deinit {
        print("DEINIT: Data Prensenter")
    }
    
    // Define properties
    var delegate: DataPresenterProtocol?
    private var resultFromCall: Root?
    
    private func cancelRequest() {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    func performSearch(with textToSearch: String) {
        // This function is used to make the api call and call the appropiate protocols
        
        // Take care of empty strings
        if textToSearch == "" {
            // Let view know and cancel any requests. This is because sometimes the response arrives after cancel is pressed
            cancelRequest()
            delegate?.emptryStringDetected()
            return
        }

        
        // cancel any ongoing request so only the newest thread returns data
        cancelRequest()
        
        // alert the view to clear the default text it is showing the user and prepare for searching
        delegate?.clearBackgroundLabel()
        
        let finalText = textToSearch.replacingOccurrences(of: " ", with: "+") // Ensure the url recieves the right format
        let libraryUrl = "https://openlibrary.org/search.json?q=\(finalText)"
        guard let url = URL(string: libraryUrl) else { return }
        
        Alamofire.request(url).responseJSON { response in
            
            switch response.result {
                
            case .success:
                
                self.delegate?.stopViewAnimation() // Alert view that it can stop animating
                if let data = response.data {
                    // Create decoder and decode the result
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        self.resultFromCall = try decoder.decode(Root.self, from: data)
                        guard let result = self.resultFromCall else {return}
                        guard let docs = result.docs else {return}
                        if docs.isEmpty {
                            // Let view know the string it wants to search has no results
                            self.delegate?.resultIsEmpty(forText: textToSearch)
                        }
                        else {
                            // Pass data so the view can use
                            self.delegate?.resultsWithData(data: docs)
                            
                        }
                        
                    } catch { print("Decoding Error \(error)") }
                }
            case .failure(let error):
                // Stop animating and show error screen here
                // TODO: - Also check if the failure is caused by cancelling the thread and don't do anything
                
                if error.localizedDescription != "cancelled" {
                    // Alert the view if the error is not a "cancelled" error. Cancelled errors occur when we stop the request by calling cancelRequest()
                    self.delegate?.errorSearching(textToSearch)
                    
                    print("Failure making request: \(error)")
                }
                
                
            }
        }
    }
}
