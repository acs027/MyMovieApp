# MyMovie

A SwiftUI-based movie app that lets users explore movies and stay updated with the latest releases. This app features API integration for fetching movie data, caching using Core Data, user-friendly interface.

<p align="center">
    <img width="364" alt="Image" src="https://github.com/user-attachments/assets/322c26f5-b2c8-458b-8163-0303982a8b43" alt="Dark mode" width="300"/>

    <img width="364" alt="Image" src="https://github.com/user-attachments/assets/9483a608-4453-47b0-8cd9-ae9595e82052" alt="Light mode" width="300"/>

    <img width="364" alt="Image" src="https://github.com/user-attachments/assets/09247216-556a-4ef5-874f-861810d5f3f4" alt="Movie List" width="300"/>

    <img width="364" alt="Image" src="https://github.com/user-attachments/assets/985c28b4-9ca1-4ec4-83d2-509df50b701f" alt="Movie Detail View" width="300"/>
</p>

## Features

- **Onboarding:** Provides a user-friendly onboarding experience to guide new users through the app's features.
- **Core Data Caching:** Caches movie data in memory for quick access, reducing unnecessary API calls.
- **Detailed Movie Info:** Provides detailed information about selected movies.
- **Access IMDb Page:** From the movie details screen, users can click a button to visit the movie's IMDb page using WebKit.
- **Search Functionality:** Users can click the search button to bring up a search view and search for their favorite movies.
- **SwiftUI Interface:** Clean and modern UI built entirely with SwiftUI.

## Requirements

- iOS 18.0+
- Xcode 16.0+

## API Integration

This app uses [TMDB API](https://www.themoviedb.org/documentation/api) to fetch movie data. The API key is stored as a string in the `Info.plist` file under the key `API_KEY`. To use this app, you need to:

1. Sign up for a TMDB API key [here](https://www.themoviedb.org/signup).
2. Add your API key to the `Info.plist`, name that as "API_KEY".

## Architecture
- **MVVM (Model-View-ViewModel)**: Separates business logic from UI code to ensure cleaner code and better testability.

## Libraries Used
- **Alamofire:** For handling network requests.
- **Core Data:** For caching movie data locally.
- **WebKit:** For opening IMDb pages directly from the app.
- **SwiftUI:** For building the user interface.

![App Demo Record](https://github.com/user-attachments/assets/52409856-b198-4f1b-a7b0-dc1d6f6c996e)
