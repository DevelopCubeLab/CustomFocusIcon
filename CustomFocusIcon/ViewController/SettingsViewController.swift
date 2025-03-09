import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let versionCode = "1.0"
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let tableTitleList = [NSLocalizedString("Mode", comment: ""), nil,NSLocalizedString("Guide", comment: ""), NSLocalizedString("SFSymbolReference", comment: ""), NSLocalizedString("About", comment: "")]
    private let tableCellList = [[NSLocalizedString("DemoMode", comment: ""), NSLocalizedString("ManualMode", comment: "")], [NSLocalizedString("ResetAlert", comment: "")],  [NSLocalizedString("ImportantTips", comment: ""), NSLocalizedString("GuideManual", comment: ""), NSLocalizedString("GuideMacOS", comment: ""), NSLocalizedString("GuideBackup", comment: ""), NSLocalizedString("GuideFilza", comment: "")], ["SF Symbols", NSLocalizedString("SFSymbolsPreview", comment: "")], [NSLocalizedString("Version", comment: ""), "GitHub"]]
    
    // 标记一下每个分组的编号，防止新增一组还需要修改好几处的代码
    private let aboutAtSection = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Settings", comment: "")
        
        // 设置表格视图的代理和数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册表格单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // 将表格视图添加到主视图
        view.addSubview(tableView)

        // 设置表格视图的布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTitleList.count
    }
    
    // MARK: - 设置每个分组的Cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellList[section].count
    }
    
    // MARK: - 设置每个分组的顶部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitleList[section]
    }
    
    // MARK: - 构造每个Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.accessoryView = .none
        cell.selectionStyle = .none
        
        cell.textLabel?.text = tableCellList[indexPath.section][indexPath.row]
        cell.textLabel?.numberOfLines = 0 // 允许换行
        
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 {
                let switchView = UISwitch(frame: .zero)
                switchView.tag = indexPath.row // 设置识别id
                if indexPath.row == 0 {
                    switchView.isOn = SettingsUtils.instance.getUseDemoMode()
                } else {
                    switchView.isOn = SettingsUtils.instance.getUseManualMode()
                    if #available(iOS 16.0, *) { // iOS 16开始拥有root权限下，强制不能更改手动模式状态
                        if FileController.checkInstallPermission() {
                            switchView.isEnabled = false
                        }
                    }
                }
                switchView.addTarget(self, action: #selector(self.onSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchView
                cell.selectionStyle = .none
                
                if #unavailable(iOS  15.0) {
                    switchView.isEnabled = false
                    cell.textLabel?.textColor = .gray
                }
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center // 居中
            cell.selectionStyle = .default // 启用选中效果
        } else if indexPath.section == 2 || indexPath.section == 3 {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default // 启用选中效果
        } else if indexPath.section == aboutAtSection { // 关于
            cell.textLabel?.numberOfLines = 0 // 允许换行
            if indexPath.row == 0 {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                cell.textLabel?.text = tableCellList[indexPath.section][indexPath.row]
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? NSLocalizedString("Unknown", comment: "")
                if version != versionCode { // 判断版本号是不是有人篡改
                    cell.detailTextLabel?.text = versionCode
                } else {
                    cell.detailTextLabel?.text = version
                }
                cell.selectionStyle = .none
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default // 启用选中效果
            }
        }
            
            
        return cell
    }
    
    // MARK: - Cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            SettingsUtils.instance.setShowAlertDialog(value: true)
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                // 显示弹窗
                let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("ImportantTipsMessage", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else { // 跳转到教程中
                var guideType: FocusModeConfigUtils.GuideType
                switch indexPath.row {
                case 1: guideType = .manual
                case 2: guideType = .macOS
                case 3: guideType = .backup
                case 4: guideType = .filza
                default: guideType = .manual
                }
                
                let guideViewController = GuideViewController(guideType: guideType)
                guideViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
                self.navigationController?.pushViewController(guideViewController, animated: true)
            }
            
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                if let url = URL(string: "https://developer.apple.com/sf-symbols/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 1 {
                if let url = URL(string: "https://havoc.app/package/sfsymbols") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else if indexPath.section == aboutAtSection {
            if indexPath.row == 1 {
                if let url = URL(string: "https://github.com/DevelopCubeLab/CustomFocusIcon") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    
    @objc func onSwitchChanged(_ sender: UISwitch) {
        if sender.tag == 0 { // 演示模式
            SettingsUtils.instance.setUseDemoMode(value: sender.isOn)
            if sender.isOn { // 检查如果开启了演示模式，就关闭手动模式
                SettingsUtils.instance.setUseManualMode(value: false)
                tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        } else if sender.tag == 1 { // 手动模式
            SettingsUtils.instance.setUseManualMode(value: sender.isOn)
            if sender.isOn { // 检查如果开启了手动模式，就关闭演示模式
                SettingsUtils.instance.setUseDemoMode(value: false)
                FileController.instance.createTipsFile() // 创建提示文件，这样就可以在文件App看到了
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }

    }
}
