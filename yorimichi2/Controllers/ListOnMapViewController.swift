//
//  ListOnMapViewController.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/11/11.
//

import UIKit

protocol ListOnMapViewControllerDelegate: AnyObject{
    func listOnMapViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType)
    func listOnMapViewControllerDidSelectSelected(index: Int, viewModel: ListExploreResultCellType)
    func listOnMapViewControllerDidSelectLiked(index: Int, viewModel: ListYorimichiLikesCellType)
    func listOnMapLeftViewControllerDidHPDoubleTapped(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel)
    
    func ListOnMapMiddleViewControllerDidYorimichiDoubleTapped(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel)
    func ListOnMapMiddleViewControllerDidHPDoubleTapped(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel)
    
}

class ListOnMapViewController: UIViewController {
    weak var delegate: ListOnMapViewControllerDelegate?

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text =  "No Post Available"
        label.textColor = .label
        label.isHidden = true
        return label
    }()
    
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        //scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    public let segmentedControllView: UISegmentedControl = {
        let titles = ["周辺のおすすめ", "ヨリミチ候補", "お気に入り"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .secondarySystemBackground
        control.selectedSegmentTintColor = .systemGray2
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(emptyLabel)
        
        view.addSubview(horizontalScrollView)
        view.addSubview(segmentedControllView)
        
        
        setUpHeaderButtons()
        
        setUpHorizontalScrollView()
        setUpLeft()
        setUpMiddle()
        setUpRight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let segmentedControllViewSize: CGFloat = view.width - 100
        segmentedControllView.frame = CGRect(x: (view.width-segmentedControllViewSize)/2, y:  20, width: segmentedControllViewSize, height: 30)
        //horizontalScrollView.frame = CGRect(x: 0, y: segmentedControllView.bottom+20, width: view.width, height: view.height - segmentedControllView.height-20)
        horizontalScrollView.frame = CGRect(x: 0, y: 30, width: view.width, height: view.height - segmentedControllView.height-20)
        emptyLabel.sizeToFit()
        emptyLabel.center = view.center
        
        
    }

    
    private func setUpHorizontalScrollView(){
        horizontalScrollView.contentSize = CGSize(width: view.width*3, height: view.height - 50)
        
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        
        //horizontalScrollView.contentOffset = CGPoint(x: view.width, y:0)
        horizontalScrollView.contentOffset = CGPoint(x: 0, y:0)
        //horizontalScrollView.isUserInteractionEnabled = false
        horizontalScrollView.delegate = self

    }
    
    public func updateLeft(with viewModels: [ListExploreResultCellType]){
        
//        let vc = ListOnMapLeftViewController()
//        horizontalScrollView.addSubview(vc.view)
//        vc.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
//
//        addChild(vc)
//        vc.didMove(toParent: self)
        guard let tmpVC = children.first as? ListOnMapLeftViewController else {
            return
        }
        tmpVC.update(with: viewModels)
    }
    
    public func updateMiddle(with viewModels: [ListExploreResultCellType]){
        
//        let vc = ListOnMapLeftViewController()
//        horizontalScrollView.addSubview(vc.view)
//        vc.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
//
//        addChild(vc)
//        vc.didMove(toParent: self)
        guard let tmpVC = children[1] as? ListOnMapMiddleViewController else {
            print("falling here...")
            return
        }
        print("going here...")
        tmpVC.update(with: viewModels)
    }
    
    public func updateRight(with viewModels: [ListYorimichiLikesCellType]){
        
//        let vc = ListOnMapLeftViewController()
//        horizontalScrollView.addSubview(vc.view)
//        vc.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
//
//        addChild(vc)
//        vc.didMove(toParent: self)
        guard let tmpVC = children[2] as? ListOnMapRightViewController else {
            return
        }
        tmpVC.update(with: viewModels)
    }
    
    private func setUpLeft(){
        let vc = ListOnMapLeftViewController()
        vc.tableView.isUserInteractionEnabled = true
        horizontalScrollView.addSubview(vc.view)
        //vc.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        vc.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        
        vc.delegate = self
        
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    private func setUpMiddle(){
        let vc = ListOnMapMiddleViewController()
        vc.tableView.isUserInteractionEnabled = true
        horizontalScrollView.addSubview(vc.view)
        vc.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    private func setUpRight(){
        let vc = ListOnMapRightViewController()
        vc.tableView.isUserInteractionEnabled = true
        horizontalScrollView.addSubview(vc.view)
        vc.view.frame = CGRect(x: view.width*2, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    
    private func setUpHeaderButtons(){


        segmentedControllView.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        
        
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl){
        horizontalScrollView.setContentOffset(CGPoint(x: view.width*CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
        
    }
    

}

extension ListOnMapViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x < (view.width){
            segmentedControllView.selectedSegmentIndex = 0
        }
        else if (scrollView.contentOffset.x >= view.width) && (scrollView.contentOffset.x < view.width*2){
            segmentedControllView.selectedSegmentIndex = 1
            
        }
        else if (scrollView.contentOffset.x >= (view.width*2)){
            segmentedControllView.selectedSegmentIndex = 2
        }
        else{
            fatalError("ListOnMapViewController seems exceeded it scroll")
        }
    }
}

extension ListOnMapViewController: ListOnMapLeftViewControllerDelegate{
    func listOnMapLeftViewControllerDidHPDoubleTapped(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        delegate?.listOnMapLeftViewControllerDidHPDoubleTapped(cell, didTapPostWith: viewModel)
    }
    
    func listOnMapLeftViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType) {
        delegate?.listOnMapViewControllerDidSelect(index: index, viewModel: viewModel)
    }
    
    
    
}

extension ListOnMapViewController: ListOnMapMiddleViewControllerDelegate{
    
    func ListOnMapMiddleViewControllerDidDoubleTapYorimichi(_ cell: ListExploreResultYorimichiTableViewCell, didTapPostWith viewModel: YorimichiAnnotationViewModel) {
        delegate?.ListOnMapMiddleViewControllerDidYorimichiDoubleTapped(cell, didTapPostWith: viewModel)
    }
    
    
    func ListOnMapMiddleViewControllerDidDoubleTapHP(_ cell: ListExploreResultHPTableViewCell, didTapPostWith viewModel: HPAnnotationViewModel) {
        delegate?.ListOnMapMiddleViewControllerDidHPDoubleTapped(cell, didTapPostWith: viewModel)
    }
    
    func ListOnMapMiddleViewControllerDidSelect(index: Int, viewModel: ListExploreResultCellType) {
        delegate?.listOnMapViewControllerDidSelectSelected(index: index, viewModel: viewModel)
    }
    
}

extension ListOnMapViewController: ListOnMapRightViewControllerDelegate{
    func ListOnMapRightViewControllerDidSelect(index: Int, viewModel: ListYorimichiLikesCellType) {
        delegate?.listOnMapViewControllerDidSelectLiked(index: index, viewModel: viewModel)
    }
}
