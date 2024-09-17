import UIKit

    // MARK: CRUD

protocol UserDefaultsManagerProtocol {

    //methods for setting new data
    func set(_ object: Any?, forKey key: UserDefaultsManager.Keys)
    func setCustomType<T: Encodable>(object: T?, forKey key: UserDefaultsManager.Keys)

    //methods for getting saved data
    func getBool(forKey key: UserDefaultsManager.Keys) -> Bool? 
    func getArray(forKey key: UserDefaultsManager.Keys) -> [Int]
    func getCodableData<T: Decodable>(forKey: UserDefaultsManager.Keys) -> T?

    //deleting data
    func delete(forKey key: UserDefaultsManager.Keys)
}


final class UserDefaultsManager {

    public enum Keys: String {
        case likedBooks = "likedBooks"
        case recent = "recent"
    }

    private let userDefaults = UserDefaults.standard

    private func storeData(_ object: Any?, key: String) {
        userDefaults.set(object, forKey: key)
    }

    private func restoreData(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}

    //MARK: UserDefaultsManagerProtocol

extension UserDefaultsManager: UserDefaultsManagerProtocol {

    func set(_ object: Any?, forKey key: Keys) {
        storeData(object, key: key.rawValue)
    }

    func setCustomType<T: Encodable>(object: T?, forKey key: Keys) {
        _ = try? JSONEncoder().encode(object)
        storeData(object, key: key.rawValue)
    }

    func getBool(forKey key: Keys) -> Bool? {
        restoreData(forKey: key.rawValue) as? Bool
    }

    func getArray(forKey key: Keys) -> [Int] {
        restoreData(forKey: key.rawValue) as? [Int] ?? [0, 1, 2]
    }

    func getCodableData<T: Decodable>(forKey key: Keys) -> T? {
        guard let data = restoreData(forKey: key.rawValue) as? Data else { return nil}
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func delete(forKey key: Keys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    func addBookToFavorites(_ key: String, category: Keys) {
        var favorites = getBook(for: category)
        if !favorites.contains(key) {
            favorites.append(key)
            saveBook(favorites, category: category)
        }
    }

    func addToRecent(_ key: String) {
        var recentBooks = getBook(for: .recent)
        if !recentBooks.contains(key) {
            recentBooks.append(key)
            saveBook(recentBooks, category: .recent)
        }
    }

    func getBook(for key: Keys) -> [String] {
        return UserDefaults.standard.stringArray(forKey: key.rawValue) ?? []
    }

    func saveBook(_ books: [String], category: Keys) {
        UserDefaults.standard.set(books, forKey: category.rawValue)
        UserDefaults.standard.synchronize()
    }

    func deleteFromFavorites(_ favorites: [String]) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.Keys.likedBooks.rawValue)    }
}
