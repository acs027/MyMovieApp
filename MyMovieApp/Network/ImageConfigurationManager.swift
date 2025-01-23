//
//  ImageConfiguration.swift
//  MyMovieApp
//
//  Created by ali cihan on 23.01.2025.
//

import Foundation

final class ImageConfigurationManager {
    static let shared = ImageConfigurationManager()
    private var service: MovieServiceProtocol
    private var imageConfiguration: ImageConfiguration? {
        didSet {
            saveImageConfigurationToUserDefaults()
        }
    }
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    func fetchConfiguration() {
        service.fetchConfiguration { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let configurationResponse):
                imageConfiguration = configurationResponse.images
            case .failure(let error):
                debugPrint("\(error.localizedDescription)")
            }
        }
        
    }
    
    private func saveImageConfigurationToUserDefaults() {
        guard let imageConfiguration else { return }
        do {
            let data = try JSONEncoder().encode(imageConfiguration)
            UserDefaults.standard.set(data, forKey: "MyMovieAppImageConfiguration")
        } catch {
            print("Failed to save image configuration: \(error.localizedDescription)")
        }
    }
    
    private func loadImageConfigurationFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "MyMovieAppImageConfiguration") else { return }
        do {
            imageConfiguration = try JSONDecoder().decode(ImageConfiguration.self, from: data)
        } catch {
            print("Failed to load image configuration: \(error.localizedDescription)")
        }
    }
    
    func getImageConfiguration() -> ImageConfiguration? {
        guard let data = UserDefaults.standard.data(forKey: "MyMovieAppImageConfiguration") else { return nil }
        do {
            imageConfiguration = try JSONDecoder().decode(ImageConfiguration.self, from: data)
            return imageConfiguration
        } catch {
            print("Failed to load image configuration: \(error.localizedDescription)")
            return nil
        }
    }
    
}

