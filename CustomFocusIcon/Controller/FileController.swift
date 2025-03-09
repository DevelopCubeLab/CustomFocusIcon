import Foundation

class FileController {
    
    // 单例实例
    static let instance = FileController()
    
    // 私有构造方法
    private init() {
        //
    }
    
    private func getFilePath(workMode: FocusModeConfigUtils.WorkMode) -> String {
        switch workMode {
        
        case .root:
            return "/var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json"
        case .manual:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("ModeConfigurations.json").path
        case .demo:
            return Bundle.main.path(forResource: "ModeConfigurations", ofType: "json") ?? ""   // 测试UI的
        case .noPermission, .notSupported:
            return ""
        }
    }
    
    // 检查Unsandbox权限的方法
    static func checkInstallPermission() -> Bool {
        let path = "/var/mobile/Library/Preferences"
        let writeable = access(path, W_OK) == 0
        return writeable
    }
    
    // 读取 JSON 并解析为 ModeConfiguration 数组
    func readModeConfigurations(workMode: FocusModeConfigUtils.WorkMode) -> [ModeConfiguration]? {
        
        if workMode == .noPermission || workMode == .notSupported {
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: getFilePath(workMode: workMode))) else {
            NSLog("CustomFocusIcon-----> 无法读取 ModeConfigurations.json")
            return nil
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let dataArray = (jsonObject as? [String: Any])?["data"] as? [[String: Any]],
              let firstData = dataArray.first,
              let modeConfigurationsDict = firstData["modeConfigurations"] as? [String: Any]
        else {
            NSLog("CustomFocusIcon-----> ModeConfigurations.json 结构不匹配")
            return nil
        }

        // 过滤 `mode` 相关内容
        var modeConfigs: [ModeConfiguration] = []
        for (_, value) in modeConfigurationsDict {
            if let modeData = (value as? [String: Any])?["mode"] as? [String: Any],
               let identifier = modeData["identifier"] as? String,
               let semanticType = modeData["semanticType"] as? Int,
               let name = modeData["name"] as? String,
               let symbolImageName = modeData["symbolImageName"] as? String? {
                
                let mode = ModeConfiguration(
                    identifier: identifier,
                    semanticType: semanticType,
                    name: name,
                    tintColorName: modeData["tintColorName"] as? String,
                    symbolDescriptorTintStyle: modeData["symbolDescriptorTintStyle"] as? Int,
                    symbolImageName: symbolImageName
                )
                modeConfigs.append(mode)
            }
        }
        
        // 按照名称排序，解决每次进入顺序不一致的问题
        modeConfigs.sort { $0.name.localizedCompare($1.name) == .orderedAscending }

        return modeConfigs
    }
    
    func backupJSONFile(workMode: FocusModeConfigUtils.WorkMode) -> Bool {
        let backupDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("backups")

        // 生成 YYYY-mm-dd-hh-mm-ss 格式的时间戳
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let timestamp = dateFormatter.string(from: Date())

        let backupFolder = backupDir.appendingPathComponent(timestamp)
        let backupFile = backupFolder.appendingPathComponent("ModeConfigurations.json")

        do {
            // 创建备份文件夹
            try FileManager.default.createDirectory(at: backupFolder, withIntermediateDirectories: true, attributes: nil)
            // 复制 JSON 文件到备份目录
            try FileManager.default.copyItem(at: URL(fileURLWithPath: getFilePath(workMode: workMode)), to: backupFile)
            
            NSLog("CustomFocusIcon-----> 配置文件备份成功: \(backupFile.path)")
            return true
        } catch {
            print("CustomFocusIcon-----> 配置文件备份失败: \(error)")
            return false
        }
    }
    
    func updateModeConfiguration(workMode: FocusModeConfigUtils.WorkMode, updatedConfig: ModeConfiguration) -> Bool {
        // 读取 JSON 文件内容
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: getFilePath(workMode: workMode))) else {
            NSLog("CustomFocusIcon-----> 无法读取 ModeConfigurations.json")
            return false
        }

        // 先创建备份
        if !backupJSONFile(workMode: workMode) {
            return false
        }

        do {
            // 解析 JSON 文件
            var jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
            
            // 获取 modeConfigurations
            guard var dataArray = jsonObject?["data"] as? [[String: Any]],
                  var modeConfigurations = dataArray.first?["modeConfigurations"] as? [String: Any] else {
                NSLog("CustomFocusIcon-----> JSON 格式不正确")
                return false
            }

            // 遍历 modeConfigurations，找到对应的 mode
            for (key, value) in modeConfigurations {
                if var modeConfig = value as? [String: Any],
                   var mode = modeConfig["mode"] as? [String: Any],
                   let identifier = mode["identifier"] as? String,
                   identifier == updatedConfig.identifier {
                    
                    // 更新 name 和 symbolImageName
                    mode["name"] = updatedConfig.name
                    mode["symbolImageName"] = updatedConfig.symbolImageName
                    
                    // 将更新后的 mode 写回 modeConfig
                    modeConfig["mode"] = mode
                    
                    // 将更新后的 modeConfig 写回 modeConfigurations
                    modeConfigurations[key] = modeConfig
                    
                    // 将更新后的 modeConfigurations 写回 dataArray
                    dataArray[0]["modeConfigurations"] = modeConfigurations
                    
                    // 将更新后的 dataArray 写回 jsonObject
                    jsonObject?["data"] = dataArray
                    
                    // 将更新后的 jsonObject 序列化为 JSON 数据
                    let updatedJsonData = try JSONSerialization.data(withJSONObject: jsonObject as Any, options: .prettyPrinted)
                    
                    // 写回 JSON 文件
                    try updatedJsonData.write(to: URL(fileURLWithPath: getFilePath(workMode: workMode)))
                    
                    NSLog("CustomFocusIcon-----> 已修改 \(updatedConfig.identifier) 的 `name` 和 `symbolImageName`")
                    return true
                }
            }
            
            NSLog("CustomFocusIcon-----> 未找到 identifier 为 \(updatedConfig.identifier) 的 mode")
            return false
        } catch {
            NSLog("CustomFocusIcon-----> 修改失败: \(error)")
            return false
        }
    }
    
    /// 创建一个提示文件，让App的沙盒目录下的Document可以显示在文件App里
    func createTipsFile() {
        let fileManager = FileManager.default

        // 获取沙盒目录路径
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        // 定义文件路径
        let fileURL = documentsURL.appendingPathComponent(NSLocalizedString("TipsFileName", comment: ""))

        // 检查文件是否存在
        if !fileManager.fileExists(atPath: fileURL.path) {
            do {
                // 如果文件不存在，则创建文件并写入内容
                // 文件内容
                let fileContent = NSLocalizedString("TipsContent", comment: "")
                try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("无法创建文件: \(error)")
            }
        }
    }

}
