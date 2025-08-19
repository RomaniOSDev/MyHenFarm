//
//  AppParameters.swift
//  TestLoadingView
//
//  Created by Роман Главацкий on 16.08.2025.
//

import Foundation

// MARK: - Network Configuration
struct NetworkConfiguration {
    var baseURL: String
    let timeoutInterval: TimeInterval
    let retryCount: Int
    let retryDelay: TimeInterval
    
    static let `default` = NetworkConfiguration(
        baseURL: "https://myhenfarm.com/config.php",
        timeoutInterval: 30.0,
        retryCount: 3,
        retryDelay: 2.0
    )
}

// MARK: - App Parameters Configuration
struct AppParameters {
    
    // MARK: - AppsFlyer Configuration
    static let appsFlyerDevKey = "Dmg2CJLkCxdZBQnwoF8gQB"
    static let appsFlyerAppID = "6749693067"
    
    // MARK: - Required Parameters for Config Endpoint
    static let requiredParameters: [String: Any] = [
        // bundle_id - Bundle ID приложения
        "bundle_id": Bundle.main.bundleIdentifier ?? "com.example.app",
        
        // os - платформа приложения
        "os": "iOS",
        
        // store_id - Store ID для iOS (с 'id' в начале)
        "store_id": "id6749693067",
        
        // locale - основная локализация устройства
        "locale": Locale.current.identifier
    ]
    
    // MARK: - Network Configuration
    static let networkConfiguration = NetworkConfiguration(
        baseURL: "https://myhenfarm.com/config.php",
        timeoutInterval: 30.0,
        retryCount: 3,
        retryDelay: 2.0
    )
}

// MARK: - AppsFlyer Parameter Extensions
extension AppParameters {
    
    /// Получить af_id (AppsFlyer ID) из AppsFlyer SDK
    /// - Returns: AppsFlyer ID или nil если недоступен
    static func getAppsFlyerID() -> String? {
        // Здесь будет вызов AppsFlyer SDK для получения ID
        // AppsFlyerLib.shared().getAppsFlyerUID() или AppsFlyerLib.shared().getAppsFlyerId()
        return nil // Пока возвращаем nil, будет реализовано позже
    }
    
    /// Получить push_token из Firebase
    /// - Returns: Push token или nil если недоступен
    static func getPushToken() -> String? {
        // Здесь будет получение push token из Firebase
        // Messaging.messaging().fcmToken
        return nil // Пока возвращаем nil, будет реализовано позже
    }
    
    /// Получить firebase_project_id
    /// - Returns: Firebase Project ID или nil если недоступен
    static func getFirebaseProjectID() -> String? {
        // Здесь будет получение Firebase Project ID
        // FirebaseApp.app()?.options.projectID
        return nil // Пока возвращаем nil, будет реализовано позже
    }
}

