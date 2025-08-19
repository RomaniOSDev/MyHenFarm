//
//  AppsFlyerManager.swift
//  TestLoadingView
//
//  Created by Роман Главацкий on 16.08.2025.
//

import Foundation
import AppsFlyerLib

// MARK: - AppsFlyer Delegate Protocol
// Используем встроенный протокол AppsFlyerLibDelegate из AppsFlyer SDK

// MARK: - AppsFlyer Manager
class AppsFlyerManager: NSObject {
    
    // MARK: - Properties
    private let devKey: String
    private let appID: String
    private var conversionData: [String: Any?] = [:]
    private var isConversionDataReceived = false
    private var pendingCompletion: (([String: Any?]) -> Void)?
    private var pendingErrorCompletion: ((NSError) -> Void)?
    
    // MARK: - Initialization
    override init() {
        self.devKey = AppParameters.appsFlyerDevKey
        self.appID = AppParameters.appsFlyerAppID
        super.init()
        
        // Настраиваем AppsFlyer SDK
        setupAppsFlyer()
    }
    
    init(devKey: String, appID: String) {
        self.devKey = devKey
        self.appID = appID
        super.init()
        
        // Настраиваем AppsFlyer SDK
        setupAppsFlyer()
    }
    
    private func setupAppsFlyer() {
        // Устанавливаем dev key и app ID
        AppsFlyerLib.shared().appsFlyerDevKey = devKey
        AppsFlyerLib.shared().appleAppID = appID
        
        // Устанавливаем delegate
        AppsFlyerLib.shared().delegate = self
        
        // Включаем отладку (убрать в продакшене)
        AppsFlyerLib.shared().isDebug = true
        
        // Запускаем AppsFlyer - он автоматически получит данные конверсии
        AppsFlyerLib.shared().start()
    }
    
    // MARK: - Public Methods
    
    /// Получить данные конверсии от AppsFlyer
    /// - Parameter completion: Callback с результатом
    func getConversionData(completion: @escaping (Result<[String: Any?], NSError>) -> Void) {
        // Сохраняем completion для использования в delegate методах
        pendingCompletion = { conversionData in
            completion(.success(conversionData))
        }
        pendingErrorCompletion = { error in
            completion(.failure(error))
        }
        
        // Проверяем, есть ли уже полученные данные
        if isConversionDataReceived && !conversionData.isEmpty {
            // Если данные уже есть, возвращаем их сразу
            pendingCompletion?(conversionData)
            return
        }
        
        // AppsFlyer автоматически получает данные конверсии при запуске
        // Данные будут получены через delegate методы
        // Если данные еще не получены, ждем их получения
    }
    
    /// Проверить, получены ли данные конверсии
    var hasConversionData: Bool {
        return isConversionDataReceived && !conversionData.isEmpty
    }
    
    /// Получить текущие данные конверсии
    var currentConversionData: [String: Any?] {
        return conversionData
    }
    
    // MARK: - Private Methods
}

// MARK: - AppsFlyerLib Delegate Implementation
extension AppsFlyerManager: AppsFlyerLibDelegate {
    func onConversionDataFail(_ error: any Error) {
        // Вызываем completion с ошибкой, чтобы LoadingView мог обработать её
        DispatchQueue.main.async { [weak self] in
            let nsError = NSError(domain: "AppsFlyer", code: 2001, userInfo: [NSLocalizedDescriptionKey: "AppsFlyer conversion data error: \(error.localizedDescription)"])
            self?.pendingErrorCompletion?(nsError)
            self?.pendingCompletion = nil
            self?.pendingErrorCompletion = nil
        }
    }
    
    /// Вызывается при успешном получении данных конверсии
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        // Преобразуем [AnyHashable: Any] в [String: Any?]
        var convertedData: [String: Any?] = [:]
        for (key, value) in conversionInfo {
            if let stringKey = key as? String {
                convertedData[stringKey] = value
            } else if let stringKey = key as? NSString {
                convertedData[stringKey as String] = value
            }
        }
        
        // Сохраняем данные
        self.conversionData = convertedData
        self.isConversionDataReceived = true
        
        // Вызываем completion с успешным результатом
        DispatchQueue.main.async { [weak self] in
            self?.pendingCompletion?(convertedData)
            self?.pendingCompletion = nil
            self?.pendingErrorCompletion = nil
        }
    }
    
    /// Вызывается при получении данных атрибуции
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        // Здесь можно обработать данные атрибуции, если нужно
        // Например, сохранить их для последующего использования
    }
    
    /// Вызывается при ошибке получения данных атрибуции
    func onAppOpenAttributionFailure(_ error: NSError) {
        // Ошибка атрибуции не критична для основной функциональности
        // Можно логировать или обрабатывать по необходимости
    }
}
