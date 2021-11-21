//
//  PostEditGenreCollectionViewCell.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/26.
//

//import UIKit
//import SafariServices
//
//protocol PostEditGenreCollectionViewCellDelegate: AnyObject{
//    func postEditGenreCollectionViewCellEndEditing(_ cell: PostEditGenreCollectionViewCell)
//}
//
//class PostEditGenreCollectionViewCell: UICollectionViewCell {
//    weak var delegate: PostEditGenreCollectionViewCellDelegate?
//
//    static let identifier = "PostEditGenreCollectionViewCell"
//
//    public let placeholder = "Select Genre..."
//
//
//    let pickerView = UIPickerView()
//    // ドラムロールボタンの選択肢を配列にして格納
//    private var dataSource: [String] = []
//
//    public let field: UITextField = {
//        let textView = TextField()
//
//        textView.layer.masksToBounds = true
//        textView.font = .systemFont(ofSize: 16)
//        textView.returnKeyType = .next
//        textView.autocorrectionType = .no
//        textView.autocapitalizationType = .none
//        textView.tintColor = UIColor.clear
//
//        return textView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.clipsToBounds = true
//        contentView.backgroundColor = .systemBackground
//
//        field.placeholder = placeholder
//
//        contentView.addSubview(field)
//
//        // pickerViewの配置するx,yと幅と高さを設定.
//        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.height)
//
//        // Delegateを自身に設定する
//        pickerView.delegate   = self
//
//        // 選択肢を自身に設定する
//        pickerView.dataSource = self
//
//
//        genreList.forEach{ genre in
//            dataSource.append(genreCodeToDisplayString(x: genre))
//        }
//
//
//        // 決定バーの生成
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentView.width, height: 50))
//        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
//        toolbar.setItems([spacelItem, doneItem], animated: true)
//
//        // UITextField編集時に表示されるキーボードをpickerViewに置き換える
//        field.inputView = pickerView
//        field.inputAccessoryView = toolbar
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        field.frame = CGRect(x: 10, y: 0, width: contentView.width-20, height: contentView.height)
//
//    }
//}
//
//extension PostEditGenreCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return dataSource[row]
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return dataSource.count
//    }
//
//
//
//    // 各選択肢が選ばれた時の操作
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch row {
//        case 0:
//            print("tapped 0")
//        case 1:
//            print("tapped 1")
//        case 2:
//            print("tapped 2")
//        case 3:
//            print("tapped 3")
//        default:
//            break
//        }
//    }
//
//    // 決定ボタン押下
//    @objc func didTapDone() {
//        field.endEditing(true)
//        field.text = "\(dataSource[pickerView.selectedRow(inComponent: 0)])"
//        delegate?.postEditGenreCollectionViewCellEndEditing(self)
//    }
//}
//
