import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var focusItems: [ModeConfiguration] = []
    
    private var workMode: FocusModeConfigUtils.WorkMode = .noPermission
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("CFBundleDisplayName", comment: "")
        
        self.checkWorkMode(showDialog: true) // 检查工作模式
        
        // 创建 "+" 按钮并添加到导航栏右侧
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(openSleepModeSettings)
        )
        
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
    
    // 显检查工作模式
    private func checkWorkMode(showDialog: Bool) {
        if FileController.checkInstallPermission() {
            if #available(iOS 16.0, *) { // iOS 16需要半自动模式
                if SettingsUtils.instance.getUseDemoMode() { // 判断用户是否强制启动演示模式
                    workMode = .demo
                } else {
                    workMode = .manual
                    SettingsUtils.instance.setUseManualMode(value: true)
                }
                self.showAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("RunWithiOS16RootMessage", comment: ""), showDialog: showDialog)
            } else if #available(iOS 15.0, *) { // iOS 15完全支持
                if SettingsUtils.instance.getUseDemoMode() { // 判断用户是否强制启动演示模式
                    workMode = .demo
                } else if SettingsUtils.instance.getUseManualMode() {
                    workMode = .manual
                } else {
                    workMode = .root
                }
            } else { // iOS 14不支持
//                if SettingsUtils.instance.getUseDemoMode() { // 判断用户是否强制启动演示模式
//                    workMode = .demo
//                } else if SettingsUtils.instance.getUseManualMode() {
//                    workMode = .manual
//                } else {
//                    workMode = .notSupported
//                }
                workMode = .notSupported
                self.showAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("RunWithiOS14Message", comment: ""), showDialog: showDialog)
            }
        } else { // 处理自签名的方法
            if SettingsUtils.instance.getUseDemoMode() { // 判断是否使用演示模式
                workMode = .demo
            } else if SettingsUtils.instance.getUseManualMode() { // 判断是否使用手动编辑模式
                workMode = .manual
                self.showAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("RunWithManualModeMessage", comment: ""), showDialog: showDialog)
            } else {
                workMode = .noPermission
                self.showAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("RunWithNoPermissionMessage", comment: ""), showDialog: showDialog)
            }
        }
    }
    
    // 显示弹窗
    func showAlert(title: String, message: String, showDialog: Bool) {
        
        if !showDialog {
            return
        }
        
        if !SettingsUtils.instance.getShowAlertDialog() {
            return
        }
            
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("DontShowAgain", comment: ""), style: .destructive, handler: { _ in
            SettingsUtils.instance.setShowAlertDialog(value: false) // 不再提示
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkWorkMode(showDialog: false)
        
        focusItems = FileController.instance.readModeConfigurations(workMode: workMode) ?? []
        tableView.reloadData()
    }
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - 设置每个分组的Cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return focusItems.count
    }
    
    // MARK: - 设置每个分组的底部标题 可以为分组设置尾部文本，如果没有尾部可以返回 nil
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch workMode {
        case .noPermission:
            return NSLocalizedString("NoPermissionFooter", comment: "")
        case .root:
            return NSLocalizedString("WorkAtRootHomeFooter", comment: "")
        case .manual:
            return String.localizedStringWithFormat(NSLocalizedString("WorkMode", comment: ""), NSLocalizedString("ManualMode", comment: "")) + "\n" + String.localizedStringWithFormat(NSLocalizedString("ManualModeCopyFileFooter", comment: ""), FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        case .demo:
            return String.localizedStringWithFormat(NSLocalizedString("WorkMode", comment: ""), NSLocalizedString("DemoMode", comment: ""))
        case .notSupported:
            return NSLocalizedString("NotSupportFooter", comment: "")
        }
    }
    
    // MARK: - 构造每个Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let mode = focusItems[indexPath.row]

        // 设置左侧 SF Symbol 图标
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: mode.symbolImageName ?? "questionmark.circle")
        content.imageProperties.tintColor = FocusModeConfigUtils.colorFromName(mode.tintColorName) // 设置颜色
        content.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22) // 设置 SF Symbol 大小

        // 设置文本
        content.text = mode.name
        cell.contentConfiguration = content

        // 右侧箭头，仅 `semanticType == -1` 类型的 可编辑
        cell.accessoryType = (mode.semanticType == -1) ? .disclosureIndicator : .none

        return cell
    }
    
    // MARK: - UITableViewDelegate 点击item的事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if focusItems[indexPath.row].semanticType == -1 { // 只有这个类型的设置才是用户自己创建的
            let mode = focusItems[indexPath.row]
            
            let editModeViewController = EditModeViewController(workMode: workMode, mode: mode)
            editModeViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
            editModeViewController.title = mode.name
            self.navigationController?.pushViewController(editModeViewController, animated: true)
        }
    }
    
    // 按钮点击事件，尝试跳转到勿扰模式 -> 睡眠模式设置
    @objc func openSleepModeSettings() {
        
        let url = URL(string: "App-prefs:root=DO_NOT_DISTURB")!

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(
                title: "无法打开设置",
                message: "请检查您的设备是否支持此跳转。",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true)
        }
        
    }

}

