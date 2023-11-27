//
//  ContentView.swift
//  GitHubProfile
//
//  Created by Ricardo on 26/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var inputNameGH: String = ""
    @State private var user: GitUser?
    var body: some View {
        VStack {
            Spacer()
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
            } placeholder: {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 100, height: 100)
            }
            
            Text(user?.login ?? "username-placeholder")
                .font(.custom("Roboto-Medium", size: 20))
                .padding(.top, 10)
                .foregroundColor(.white)
            
            HStack {
                
                Text(user?.name ?? "name")
                    .font(.custom("Roboto-Regular", size: 16))
                    .foregroundColor(.white)
                    .padding(.top, 2)
                
                Text(" - ")
                    .foregroundColor(.white)
                
                let reposLabel: String = "Pub. Repos: \(String(describing: user?.publicRepos ?? 0))"
                
                Text(reposLabel)
                    .foregroundColor(.white)
            }
            
            HStack {
                Image(systemName: "star")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 14.0, height: 14.0)
                
                let followersLabel = "\(String(describing: user?.followers ?? 0)) followers"
                Text(followersLabel)
                    .font(.custom("Roboto-Medium", size: 16))
                    .foregroundColor(.white)
            }
            .frame(height: 30)
                
            
            Text(user?.bio ?? "Here is the bio of the user searched on GitHub.")
                .font(.custom("Roboto-Light", size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 2)
                .multilineTextAlignment(.center)
            
            TextField("Digite aqui o nome do perfil no GitHub…", text: $inputNameGH)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.black)
                .colorInvert()
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Button(action: {
                Task {
                    do {
                        user = try await getUserGitHub(name: inputNameGH)
                    } catch GHError.invalidURL {
                        print("invalid url…")
                    } catch GHError.invalidResponse {
                        print("invalid response…")
                    } catch GHError.invalidData {
                        print("invalid data…")
                    } catch {
                        print("unexpected error")
                    }
                }
            }) {
                Text("Buscar")
                    .padding(10)
                    .padding(.horizontal, 10)
            }
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(6)
            .padding(26)
            .frame(maxWidth: .infinity)
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        
    }
    
    func getUserGitHub(name: String) async throws -> GitUser? {
        let endpoint = "https://api.github.com/users/\(name)"
        
        guard let url = URL(string: endpoint) else { throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
