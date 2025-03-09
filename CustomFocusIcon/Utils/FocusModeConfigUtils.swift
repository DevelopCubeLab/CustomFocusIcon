import Foundation
import UIKit

class FocusModeConfigUtils {
    
    enum WorkMode: Int {
        case noPermission = 0   // 无权限
        case root = 1           // iOS 15的课正常读写模式
        case manual = 2         // iOS 16和17.0的半自动模式
        case demo = 3           // 演示模式
        case notSupported = 4   // iOS 14不支持
    }
    
    enum GuideType: Int {
        case filza = 0     // Filza手动模式
        case manual = 1    // 复制文件的手动模式
        case macOS = 2     // 使用macOS修改
        case backup = 3    // 备份和恢复备份
    }
    
    /// 颜色转换
    static func colorFromName(_ name: String?) -> UIColor {
        switch name {
        case "systemBlueColor": return .systemBlue
        case "systemRedColor": return .systemRed
        case "systemGreenColor": return .systemGreen
        case "systemOrangeColor": return .systemOrange
        case "systemMintColor": if #available(iOS 15.0, *) {
            return .systemMint
        } else {
            // Fallback on earlier versions
            return .systemBlue
        }
        case "systemPurpleColor": return .systemPurple
        case "systemTealColor": return .systemTeal
        case "systemPinkColor": return .systemPink
        case "systemIndigoColor": return .systemIndigo
        default: return .gray
        }
    }
    
    // 检查SY Symbol是否可用
    static func isSFSymbolAvailable(symbolName: String) -> Bool {
        return UIImage(systemName: symbolName) != nil
    }
    
    // 获取本机IPv4地址，用于显示教程的时候提示用户如何使用电脑连接到ssh
    static func getWiFiIPAddress() -> String? {
        var address: String?

        // 获取所有网络接口
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let interface = ptr!.pointee

                // 仅获取 IPv4 地址
                if interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) {
                    let name = String(cString: interface.ifa_name)

                    // 仅检查 Wi-Fi（en0）
                    if name == "en0" {
                        var addr = interface.ifa_addr.pointee
                        var buffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                    &buffer, socklen_t(buffer.count), nil, 0, NI_NUMERICHOST)
                        address = String(cString: buffer)
                        break // 取第一个有效 IP
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
}
