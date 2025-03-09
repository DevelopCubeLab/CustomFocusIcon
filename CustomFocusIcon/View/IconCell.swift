import Foundation
import UIKit

class IconCell: UITableViewCell {
    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    
    func configure(with symbol: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: Date()) // 当前日期
        timeLabel.textColor = .label
        timeLabel.font = UIFont.systemFont(ofSize: 19, weight: UIAccessibility.isBoldTextEnabled ? .bold : .regular) // 字体，顺便判断用户是否开启加粗字体，开启把字体加粗
        
        iconView.image = UIImage(systemName: symbol)
        iconView.tintColor = .label
        iconView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconView])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
