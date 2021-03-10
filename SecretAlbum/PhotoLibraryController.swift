//
//  PhotoLibraryController.swift
//  SecretAlbum
//
//  Created by 100 on 05.03.2021.
//

import UIKit
import Photos

protocol KhajaPhotoLibraryDelegate: class{
    func getSelectedLibrary(images:[UIImage])
}

protocol PhotoFetcher: class{
    func getImages(completion: @escaping ([UIImage]) -> ())
}


import UIKit
import Photos

class PhotoLibraryController: UIViewController, PhotoFetcher {
   
    @IBOutlet weak var collectionView: UICollectionView!
    //    @IBOutlet weak var submitButton: UIButton!
    
    
    var images = [UIImage]()
    var selectedImage: UIImage?
    var multiSelect: Bool = false
    var selectedIndexes: [Int:Bool] = [:]
//    weak var delegate: Mappable?
    weak var delegate: KhajaPhotoLibraryDelegate?
    let titleLabel = UILabel()
    var count = 0
    lazy var titleStackView: UIStackView = {
//            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
        titleLabel.font = titleLabel.font.withSize(16)
            titleLabel.text = "Import files to your space"
            let subtitleLabel = UILabel()
            subtitleLabel.textAlignment = .center
            subtitleLabel.text = "Photo no exif"
        subtitleLabel.font = subtitleLabel.font.withSize(14)
            let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            stackView.axis = .vertical
            return stackView
        }()
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            if view.traitCollection.horizontalSizeClass == .compact {
                titleStackView.axis = .vertical
                if #available(iOS 11.0, *) {
                    titleStackView.spacing = UIStackView.spacingUseDefault
                } else {
                    // Fallback on earlier versions
                }
//                titleStackView.spacing = 20.0
            } else {
                titleStackView.axis = .horizontal
                titleStackView.spacing = 20.0
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getImages { images in
            self.images = images
            self.collectionView.reloadData()
        }
        
        self.navigationItem.titleView = titleStackView
        
//        submitButton.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Albums", style: .plain, target: self, action: #selector(dimissedviewcontroller))
        self.navigationItem.leftBarButtonItem?.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(multiSelectPressed))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    @objc func dimissedviewcontroller() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func multiSelectPressed(){
        multiSelect = !multiSelect
//        self.submitButton.isHidden = !multiSelect
        self.selectedIndexes.removeAll()
        self.collectionView.reloadData()
    }
    
    
//    @IBAction func submitButton(_ sender: UIButton) {
//        var photosToSend = [UIImage]()
//
//        for (key, value) in selectedIndexes {
//            if value{
//                photosToSend.append(self.images[key])
//            }
//        }
//
//        if delegate != nil  && images.count > 0{
//            delegate!.getSelectedLibrary(images:photosToSend)
//        }
//
//        self.navigationController?.popViewController(animated: true)
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == String(describing: SeeImageController.self){
//            if let seeImageController = segue.destination as? SeeImageController{
//                seeImageController.image = selectedImage
//            }
//        }
    }
    
}


extension PhotoLibraryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AssetCollectionViewCell
        
        let row = indexPath.row
        
        
//        if multiSelect {
            cell.checkBox.isHidden = false
//            cell.layer.borderWidth = 5
            
            // check to see if this box is selected
            if let selected = selectedIndexes[row]{
                if selected{
                    cell.checkBox.image = #imageLiteral(resourceName: "checkmark")
//                    self.navigationItem.rightBarButtonItem?.isEnabled = true
//                    cell.layer.borderColor = UIColor.green.cgColor
                }
                    
                else {
                    cell.checkBox.image = nil
//                    cell.layer.borderColor = UIColor.black.cgColor
                }
            }
                
            else {
                cell.checkBox.image = nil
//                cell.layer.borderColor = UIColor.black.cgColor
            }
//        }
//
//        else{
//            cell.checkBox.isHidden = true
//            cell.layer.borderWidth = 0
//        }
//
        
        cell.imageView.image = images[row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        selectedImage = images[row]
        
//        if multiSelect{
            //this item has been selected before
            if let selected = selectedIndexes[row]{
                if selected {
                    selectedIndexes[row] = false
                    count -= 1
                    titleLabel.text = "Import \(count) files to your space"
                    if count > 0 {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    } else if count <= 0 {
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        titleLabel.text = "Import  files to your space"
                    }
                }
                else{
                    selectedIndexes[row] = true
                    count += 1
                    titleLabel.text = "Import \(count) files to your space"
                    if count > 0 {
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    } else if count <= 0 {
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        titleLabel.text = "Import  files to your space"
                    }
                }
            }
                
                // this item is being selected for the first time
            else{
                selectedIndexes[row] = true
                count += 1
                titleLabel.text = "Import \(count) files to your space"
                if count > 0 {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                } else if count <= 0 {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    titleLabel.text = "Import  files to your space"
                }
            }
            
            self.collectionView.reloadItems(at: [indexPath])
//        }
//
//        else{
////            performSegue(withIdentifier: String(describing: SeeImageController.self), sender: self)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}




// Currenlty repeating activity with asset getting; refactor



extension PhotoFetcher {
    
    
    
    func fetchPhotos(imgManager: PHImageManager, fetchResult: PHFetchResult<PHAsset>, requestOptions: PHImageRequestOptions, completion: @escaping ([UIImage]) -> ()){
        
        var output = [UIImage]()
        let output_dispatch = DispatchGroup()
        
        
        
        //Options for retrieving meta data
        let editingOtions = PHContentEditingInputRequestOptions()
        editingOtions.isNetworkAccessAllowed = true
        
        for i in 0..<fetchResult.count {
            
            let asset = fetchResult.object(at: i)
            output_dispatch.enter()
            
            
            // desired size of returned images
            let size = CGSize(width: 200, height: 200)
            
            // Only returning photos with image data, Request the image of given quality sychronously
            imgManager.requestImage(for: asset,
                                    targetSize: size,
                                    contentMode: .aspectFit,
                                    options: requestOptions,
                                    resultHandler: { image, info in
                                            output.append(image!)
                        
            })
            
            
            output_dispatch.leave()
            
        }
        
        output_dispatch.notify(queue: DispatchQueue.main) {
            completion(output)
        }
    }
    
    
    func getImages(completion: @escaping ([UIImage]) -> ()){
        // Declare a singleton of PHImangeManger class
        let imgManager = PHImageManager.default()
        
        // Requestion options determine media type, and quality
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        // Options for retrieving photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        
        if fetchResult.count > 0 {
            fetchPhotos(imgManager: imgManager, fetchResult: fetchResult, requestOptions: requestOptions, completion: { images in
                completion(images)
            })
        }
            
        else{
            return
        }
    }
}
