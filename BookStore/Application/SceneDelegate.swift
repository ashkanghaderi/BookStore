import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let savedDarkMode = UserDefaults.standard.bool(forKey: "AppDarkMode")
        let selectedTheme: UIUserInterfaceStyle = savedDarkMode ? .dark : .light
        window?.overrideUserInterfaceStyle = selectedTheme
        window?.rootViewController = LaunchViewController()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let navigationController = UINavigationController(rootViewController: HomeVC())
                self.window?.rootViewController = navigationController
            }
        window?.makeKeyAndVisible()
    }
}

