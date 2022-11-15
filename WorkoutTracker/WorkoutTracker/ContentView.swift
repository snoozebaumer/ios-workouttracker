//
//  ContentView.swift
//  testRequest
//
//  Created by Samuel Nussbaumer on 08.11.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Connect to server") {
                connectToServer()
            }
        }
        .padding()
    }
    
    func connectToServer() -> Void {
        guard let url =  URL(string:"http://localhost:3000")
        else{
            return
        }
        let message = "Hello World"
        
        let body = "message=\(message)"
        let finalBody = body.data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            print(response as Any)
            if let error = error {
                print(error)
                return
            }
            guard let data = data else{
                return
            }
            print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
            
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
