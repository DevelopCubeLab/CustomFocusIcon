import Foundation

/// 配置文件
struct ModeConfiguration: Codable {
    let identifier: String                  // 唯一标识符
    let semanticType: Int                   // 专注模式的类型，-1是用户创建的，其余都是系统生成的
    var name: String                        // 专注模式名称
    var tintColorName: String?              // 背景颜色 系统固定的几个颜色
    var symbolDescriptorTintStyle: Int?     // 暂时不知道
    var symbolImageName: String?            // 图标的SF Symbol名称
}

// 配合Json解析的顶层
struct ModeConfigurationsData: Codable {
    let modeConfigurations: [String: ModeConfiguration]
}
