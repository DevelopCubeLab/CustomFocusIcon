import Foundation

class SettingsUtils {
    // 单例实例
    static let instance = SettingsUtils()
    
    // 私有的 PlistManagerUtils 实例，用于管理特定的 plist 文件
    private let plistManager: PlistManagerUtils
    
    private init() {
        // 初始化
        self.plistManager = PlistManagerUtils.instance(for: "Settings")
    }
    
    func getShowAlertDialog() -> Bool {
        return plistManager.getBool(key: "ShowAlertDialog", defaultValue: true)
    }
    
    func setShowAlertDialog(value: Bool) {
        plistManager.setBool(key: "ShowAlertDialog", value: value)
        plistManager.apply()
    }
    
    func getUseDemoMode() -> Bool {
        return plistManager.getBool(key: "DemoMode", defaultValue: false)
    }
    
    func setUseDemoMode(value: Bool) {
        plistManager.setBool(key: "DemoMode", value: value)
        plistManager.apply()
    }
    
    func getUseManualMode() -> Bool {
        return plistManager.getBool(key: "ManualMode", defaultValue: false)
    }
    
    func setUseManualMode(value: Bool) {
        plistManager.setBool(key: "ManualMode", value: value)
        plistManager.apply()
    }
}
