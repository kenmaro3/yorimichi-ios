//
//  SwitchTableViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/06.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject{
    func switchTableViewCell(_ cell: SwitchTableViewCell, didupdateSwitchTo isOn: Bool)
    
}

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    public var type: SwitchType = SwitchType.video
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let _switch: UISwitch = {
        let _switch = UISwitch()
        _switch.onTintColor = .systemBlue
        return _switch
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        contentView.addSubview(label)
        contentView.addSubview(_switch)
        _switch.addTarget(self, action: #selector(didChangeSwitchValue), for: .valueChanged)
    }
    
    @objc func didChangeSwitchValue(_ sender: UISwitch){
        delegate?.switchTableViewCell(self, didupdateSwitchTo: sender.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.sizeToFit()
        label.frame = CGRect(x: 20, y: 0, width: label.width, height: contentView.height)
        
        _switch.sizeToFit()
        _switch.frame = CGRect(x: contentView.width - _switch.width - 10, y: (contentView.height-_switch.height)/2, width: _switch.width, height: _switch.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with viewModel: SwitchCellViewModel){
        label.text = viewModel.title
        _switch.isOn = viewModel.isOn
        type = viewModel.type
        
    }
    
    

}
