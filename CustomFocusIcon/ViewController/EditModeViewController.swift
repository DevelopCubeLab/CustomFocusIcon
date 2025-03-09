import Foundation
import UIKit

class EditModeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GridCellDelegate {
    
    private let workMode: FocusModeConfigUtils.WorkMode
    
    private var mode: ModeConfiguration
    
    private var invalidSFSymbol = false // 检查SF Symbol是否有效的标识符
//    private var verifiedIcon = false // 是否是验证过的icon

    // 提供预置的推荐图标列表
    private let symbolOptions = ["bell.slash.fill", "bell.fill","bell.badge.fill", "airplane", "wifi", "wifi.slash", "wifi.exclamationmark", "wifi.circle.fill",  "antenna.radiowaves.left.and.right", "antenna.radiowaves.left.and.right.circle.fill", "chart.bar.fill","network", "network.badge.shield.half.filled", "gear", "personalhotspot","personalhotspot.circle.fill","bolt.fill", "sun.max.fill","cloud.fill", "cloud.rain.fill", "snowflake", "airpods", "macpro.gen2.fill", "cable.connector" , "4k.tv.fill", "phone.fill","camera.circle.fill", "gamecontroller.fill", "clock.fill", "hourglass", "alarm.fill","livephoto", "photo.artframe", "photo.fill", "music.note", "paperplane.fill", "envelope", "paperclip", "gift.fill","infinity.circle.fill", "infinity","figure.walk", "figure.walk.diamond.fill", "figure.wave", "airplane.departure","archivebox.fill", "checkmark.seal.fill", "nosign","lock.fill", "lock.open.fill", "lock.circle.fill", "key.fill", "fuelpump.fill","power.circle.fill",  "barometer","externaldrive.fill", "folder.fill.badge.minus","hand.raised.fill", "tray.fill", "safari.fill", "train.side.front.car", "train.side.rear.car", "car.fill", "plus.magnifyingglass", "minus.magnifyingglass", "eye.fill", "eye.slash.fill"]
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let tableTitleList = [
        NSLocalizedString("PreviewIcon", comment: ""),
        NSLocalizedString("IconSFSymbolName", comment: ""),
        NSLocalizedString("FocusModeName", comment: ""),
        NSLocalizedString("RecommendIcon", comment: ""),
        nil]
    
    // 自定义初始化方法
    init(workMode: FocusModeConfigUtils.WorkMode, mode: ModeConfiguration) {
        self.workMode = workMode
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(IconCell.self, forCellReuseIdentifier: "IconCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
        tableView.register(GridCell.self, forCellReuseIdentifier: "GridCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    // MARK: - 设置每个分组的Cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 3
        }
        return 1
    }
    
    // MARK: - 设置每个分组的Cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return indexPath.section == 3 ? 200 : UITableView.automaticDimension
        }
    
    // MARK: - 设置每个分组的顶部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitleList[section]
    }
    
    // MARK: - 设置每个分组的底部标题 可以为分组设置尾部文本，如果没有尾部可以返回 nil
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 1 {
            return NSLocalizedString("SFSymbolTextFooter", comment: "")
        } else if section == 2 {
            return NSLocalizedString("ModeNameTextFooter", comment: "")
        }
        return nil
    }
    
    // MARK: - 构造每个Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath) as! IconCell
            cell.configure(with: mode.symbolImageName ?? "")
            cell.selectionStyle = .none // 取消cell点击效果
            return cell
        case 1, 2:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "TextFieldCell")
                cell.selectionStyle = .none // 取消cell点击效果
                let textField = UITextField(frame: CGRect(x: 18, y: 0, width: cell.contentView.frame.width - 35, height: cell.contentView.frame.height))
                textField.borderStyle = .none  // 取消显示边框
                textField.tag = indexPath.section // 设置一个tag
                textField.text = indexPath.section == 1 ? (mode.symbolImageName ?? "") : mode.name
                textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
                textField.returnKeyType = .done // 设置回车键类型
                textField.delegate = self // 设置代理
                cell.contentView.addSubview(textField)
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                if indexPath.row == 1 {
                    if workMode == .root || workMode == .manual {
                        cell.textLabel?.text = NSLocalizedString("Paste", comment: "")
                    } else {
                        cell.textLabel?.text = NSLocalizedString("Copy", comment: "")
                    }
                } else {
                    cell.textLabel?.text = NSLocalizedString("TestIcon", comment: "")
                }
                cell.textLabel?.textColor = .systemBlue
                cell.textLabel?.textAlignment = .natural
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath) as! GridCell
            cell.selectionStyle = .none // 取消cell点击效果
            cell.configure(with: symbolOptions)
            cell.delegate = self // 设置代理
            return cell
        case 4:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = NSLocalizedString("Save", comment: "")
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.textAlignment = .center // 居中
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate 点击item的事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 先隐藏键盘
        tableView.endEditing(true)
        
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                if workMode == .root || workMode == .manual { // 粘贴
                    if let symobolName = UIPasteboard.general.string {
                        mode.symbolImageName = symobolName
                        didSelectSymbol(symobolName)
                    }
                } else { // 复制
                    if let symobolName = mode.symbolImageName {
                        UIPasteboard.general.string = mode.symbolImageName
                        showTextAlert(title: NSLocalizedString("Alert", comment: ""), message: String.localizedStringWithFormat(NSLocalizedString("CopySFSymbol", comment: ""), symobolName), showRebootButton: false)
                    }
                }
            } else if indexPath.row == 2 {
                didSelectSymbol(mode.symbolImageName!)
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 0 {
                if workMode == .demo {
                    showTextAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("DemoModeNotSupportedEditMessage", comment: ""), showRebootButton: false)
                } else {
                    if invalidSFSymbol {
                        self.showTextAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("InvalidSFSymbolMessage", comment: ""), showRebootButton: false)
                    } else {
                        // 显示确认弹窗
                        let alertController = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("ConfirmSaveMessage", comment: ""), preferredStyle: .alert)
                        // 确定按钮
                        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .destructive) { _ in
                            if FileController.instance.updateModeConfiguration(workMode: self.workMode,updatedConfig: self.mode) {
                                
                                if self.workMode == .root {
                                    self.showTextAlert(title: NSLocalizedString("Alert", comment: ""), message: String.localizedStringWithFormat(NSLocalizedString("ModifySuccessfulWithRoot", comment: ""), FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("backups").path), showRebootButton: true)
                                } else if self.workMode == .manual {
                                    self.showTextAlert(title: NSLocalizedString("Alert", comment: ""), message: String.localizedStringWithFormat(NSLocalizedString("ModifySuccessfulWithManual", comment: ""), FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("backups").path), showRebootButton: false)
                                }
                                
                            }
                        }
                        // 取消按钮
                        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                        // 添加按钮到弹窗
                        alertController.addAction(confirmAction)
                        alertController.addAction(cancelAction)
                        // 显示弹窗
                        DispatchQueue.main.async {
                            self.view.endEditing(true)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    // 关闭键盘
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldChanged(_ sender: UITextField) { // 文本框内容更新
        
        if let text = sender.text {
            if sender.tag == 1 {
                mode.symbolImageName = text
            } else if sender.tag == 2 {
                mode.name = text
                title = text
            }
        }
    }
    
    // 代理方法: 处理 SF Symbol 选择
    func didSelectSymbol(_ symbol: String) {
        print("当前选中的SF Symbol: \(symbol)")
        mode.symbolImageName = symbol // 更新数据
        tableView.reloadData() // 更新UI界面
        
        if !FocusModeConfigUtils.isSFSymbolAvailable(symbolName: symbol) { // 检查SF Symbol是否有效
            invalidSFSymbol = true // 修改标记
            self.showTextAlert(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("NotSupportedSFSymbolMessage", comment: ""), showRebootButton: false)
        } else {
            invalidSFSymbol = false
        }
    }
    
    // 显示文本弹窗
    private func showTextAlert(title: String, message: String, showRebootButton: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if showRebootButton {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Reboot", comment: ""), style: .destructive) { _ in
                let deviceController = DeviceController()
                deviceController.rebootDevice()
            })
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension EditModeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 关闭键盘
        return true
    }
}


