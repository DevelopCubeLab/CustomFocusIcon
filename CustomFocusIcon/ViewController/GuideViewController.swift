import Foundation
import UIKit

class GuideViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let guideType: FocusModeConfigUtils.GuideType
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var guideContent: String = ""
    
    private var guideConsole: [String] = []
    
    // 自定义初始化方法
    init(guideType: FocusModeConfigUtils.GuideType) {
        self.guideType = guideType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        view.backgroundColor = .systemBackground
        
        // 创建沙盒提示文件
        FileController.instance.createTipsFile()
        
        switch guideType {
        case .manual:
            title = NSLocalizedString("GuideManual", comment: "")
            guideConsole = ["su", "ssh root@".appending(FocusModeConfigUtils.getWiFiIPAddress() ?? ""), "cp /var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json ".appending(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path), "chown mobile:mobile " + FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/ModeConfigurations.json "),"cp " + FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/ModeConfigurations.json ").appending("/var/mobile/Library/DoNotDisturb/DB/"), "chown mobile:wheel /var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json"]
            guideContent = String.localizedStringWithFormat(NSLocalizedString("GuideManualContent", comment: ""), guideConsole[1], guideConsole[2], guideConsole[3], guideConsole[4], guideConsole[4])
        case .macOS:
            title = NSLocalizedString("GuideMacOS", comment: "")
            guideContent = NSLocalizedString("GuideMacOSContent", comment: "")
            guideConsole = ["~/Library/DoNotDisturb/DB/ModeConfigurations.json", "~/Library/DoNotDisturb/DB/"]
        case .backup:
            title = NSLocalizedString("GuideBackup", comment: "")
            guideContent = NSLocalizedString("GuideBackupContent", comment: "")
            guideConsole = ["/HomeDomain/Library/DoNotDisturb/DB/ModeConfigurations.json"]
        case .filza:
            title = NSLocalizedString("GuideFilza", comment: "")
            guideContent = NSLocalizedString("GuideFilzaContent", comment: "")
            guideConsole = ["/var/mobile/Library/DoNotDisturb/DB/ModeConfigurations.json"]
        }
        
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
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return guideConsole.isEmpty ? 1 : 2
    }
    
    // MARK: - 设置每个分组的Cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return guideConsole.count
        } else {
            return 1
        }
    }
    
    // MARK: - 设置每个分组的顶部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Guide", comment: "")
        } else {
            return NSLocalizedString("RequiredCommands", comment: "")
        }
    }
    
    // MARK: - 设置每个分组的底部标题 可以为分组设置尾部文本，如果没有尾部可以返回 nil
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 1 {
            return NSLocalizedString("CopyCommandsFooter", comment: "")
        }
        return nil
    }
    
    // MARK: - 构造每个Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = guideContent
        } else {
            cell.textLabel?.text = guideConsole[indexPath.row]
        }
        
        cell.textLabel?.numberOfLines = 0 // 允许换行
        cell.selectionStyle = .none // 取消cell点击效果
        return cell
    }
    
    // MARK: - iOS 13+ 长按菜单 (UIContextMenuConfiguration)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: NSLocalizedString("Copy", comment: ""), image: UIImage(systemName: "doc.on.doc")) { _ in
                let cell = tableView.cellForRow(at: indexPath)
                UIPasteboard.general.string = cell?.textLabel?.text
            }
            
            return UIMenu(title: "", children: [editAction])
        }
    }
    
    // MARK: - 左侧添加“复制”按钮
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let copyAction = UIContextualAction(style: .normal, title: NSLocalizedString("Copy", comment: "")) { (action, view, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            UIPasteboard.general.string = cell?.textLabel?.text
            completionHandler(true)
        }
        copyAction.backgroundColor = .systemBlue // 复制按钮颜色
        
        return UISwipeActionsConfiguration(actions: [copyAction])
        
    }
}
