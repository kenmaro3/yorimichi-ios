//
//  CustomAnnotationViewModel.swift
//  yorimichi2
//
//  Created by Kentaro Mihara on 2021/10/31.
//

import Foundation
import Mapbox

class SelectedAnnotationViewModel: MGLPointAnnotation{
    public var id: String
    public var image: UIImage
    
    init(id: String){
        self.id = id
        if let tmpImage = UIImage(named: "logo"){
            self.image = tmpImage
        }
        else{
            self.image = UIImage()
        }
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class YorimichiAnnotationViewModel: MGLPointAnnotation{
    public var id: String
    public var post: Post
    public var selectedForYorimichi: Bool = false
    
    init(id: String, post: Post){
        self.id = id
        self.post = post
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func select(){
        selectedForYorimichi = true
    }
    
    public func deselect(){
        selectedForYorimichi = false
    }
}

class LikesAnnotationViewModel: MGLPointAnnotation{
    public var id: String
    public var post: Post
    
    init(id: String, post: Post){
        self.id = id
        self.post = post
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class HPAnnotationViewModel: MGLPointAnnotation{
    public var id: String
    public var url: String
    public var jumpUrl: String
    public var shop: Shop
    
    init(id: String, url: String, jumpUrl: String, shop: Shop){
        self.id = id
        self.url = url
        self.jumpUrl = jumpUrl
        self.shop = shop
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GoogleAnnotationViewModel: MGLPointAnnotation{
    public var id: String
    public var image: UIImage
    public var shop: Shop
    
    init(id: String, image: UIImage, shop: Shop){
        self.id = id
        self.image = image
        self.shop = shop
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CurrentLocationAnnotationViewModel: MGLPointAnnotation{
    private var url: String
    
    init(url: String){
        self.url = url
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DestinationAnnotationViewModel: MGLPointAnnotation{
    private var url: String
    
    init(url: String){
        self.url = url
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
