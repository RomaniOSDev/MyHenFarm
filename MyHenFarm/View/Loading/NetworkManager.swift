//
//  NetworkManager.swift
//  TestLoadingView
//
//  Created by Роман Главацкий on 16.08.2025.
//
import Foundation

class NetworkManager {
    private let configuration: NetworkConfiguration
    
    init(configuration: NetworkConfiguration = .default) {
        self.configuration = configuration
    }
    
    convenience init(baseURL: String) {
        var config = AppParameters.networkConfiguration
        config.baseURL = baseURL
        self.init(configuration: config)
    }
    
    func sendConversionData(appsFlyerData: [String: Any?], additionalData: [String: Any], completion: @escaping (Result<Data, NSError>) -> Void) {
        // Формируем полный URL
        guard let url = URL(string: configuration.baseURL) else {
            let nsError = NSError(domain: "NetworkManager", code: 1001, userInfo: [NSLocalizedDescriptionKey: NetworkError.invalidURL.errorDescription ?? "Invalid URL"])
            completion(.failure(nsError))
            return
        }
        
        // Подготавливаем тело запроса
        let requestBody = prepareRequestBody(appsFlyerData: appsFlyerData, additionalData: additionalData)
        
        // Создаем URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = configuration.timeoutInterval
        
        // Преобразуем параметры в JSON данные
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            let nsError = NSError(domain: "NetworkManager", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(error.localizedDescription)"])
            completion(.failure(nsError))
            return
        }
        
        // Создаем URLSession задачу
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Обрабатываем ошибки
            if let error = error {
                let nsError = NSError(domain: "NetworkManager", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Network error: \(error.localizedDescription)"])
                completion(.failure(nsError))
                return
            }
            
            // Проверяем HTTP статус
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    break // Успешный статус
                default:
                    let nsError = NSError(domain: "NetworkManager", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: NetworkError.serverError(statusCode: httpResponse.statusCode).errorDescription ?? "Server error"])
                    completion(.failure(nsError))
                    return
                }
            }
            
            // Проверяем наличие данных
            guard let data = data else {
                let nsError = NSError(domain: "NetworkManager", code: 1004, userInfo: [NSLocalizedDescriptionKey: NetworkError.noData.errorDescription ?? "No data"])
                completion(.failure(nsError))
                return
            }
            
            // Возвращаем успешный результат с данными
            completion(.success(data))
        }
        
        // Запускаем задачу
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func prepareRequestBody(appsFlyerData: [String: Any?], additionalData: [String: Any]) -> [String: Any] {
        var requestBody: [String: Any] = [:]
        
        // Добавляем данные AppsFlyer, фильтруя nil значения
        for (key, value) in appsFlyerData {
            if value != nil {
                requestBody[key] = value!
            }
        }
        
        // Добавляем дополнительные данные
        additionalData.forEach { requestBody[$0.key] = $0.value }
        
        // Добавляем timestamp
        requestBody["timestamp"] = Date().timeIntervalSince1970
        
        return requestBody
    }
    
    // Перечисление для ошибок сети
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case noData
        case serverError(statusCode: Int)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Неверный URL"
            case .noData:
                return "Нет данных в ответе"
            case .serverError(let statusCode):
                return "Ошибка сервера (\(statusCode))"
            }
        }
    }
}
