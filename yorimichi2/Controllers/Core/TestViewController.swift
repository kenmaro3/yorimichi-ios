import UIKit

class TestViewController: UIViewController {
    private let textRate:UITextView = UITextView()
    private let labelRate:UILabel = UILabel()
    private let buttonDraw:UIButton = UIButton()
    private let chartView:ChartView = ChartView()

    override func viewDidLoad() {
        super.viewDidLoad()

        textRate.layer.cornerRadius = 10
        textRate.layer.borderColor = UIColor.lightGray.cgColor
        textRate.layer.borderWidth = 0.5
        textRate.keyboardType = .numberPad
        textRate.text = "75" //とりあえずデフォル値は75%
        textRate.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(textRate)

        labelRate.text = "%"
        self.view.addSubview(labelRate)
        buttonDraw.setTitle("グラフ表示", for: .normal)
        buttonDraw.setTitleColor(UIColor.blue, for: .normal)
        buttonDraw.addTarget(self, action: #selector(self.touchUpButtonDraw), for: .touchUpInside)
        self.view.addSubview(buttonDraw)

        self.view.addSubview(chartView)

        changeScreen()
    }

    /**
     端末の向きの変更のイベント
     */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.changeScreen()
        }
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        drawChart()
    }

    private func changeScreen(){
        let screenSize: CGRect = UIScreen.main.bounds
        let widthValue = screenSize.width
        let heightValue = screenSize.height

        textRate.frame = CGRect(x: widthValue/2-170, y: 150, width: 100, height: 40)
        labelRate.frame = CGRect(x: widthValue/2-70, y: 150, width: 40, height: 40)
        buttonDraw.frame = CGRect(x: widthValue/2-30, y: 150, width: 200, height: 40)

        var drawWidth = widthValue * 0.8
        if (widthValue > heightValue){
            drawWidth = heightValue * 0.8
        }
        chartView.frame = CGRect(x: widthValue/2-drawWidth/2, y: 250, width: drawWidth, height: drawWidth)

    }

    @objc func touchUpButtonDraw(){
        drawChart()
        textRate.resignFirstResponder()
    }

    /**
     グラフを表示
     */
    private func drawChart(){
        guard let rate = Double(textRate.text!) else {
            return
        }
        chartView.drawChart(rate: rate)
    }
}
