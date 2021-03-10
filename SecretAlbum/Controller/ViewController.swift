//
//  ViewController.swift
//  SecretAlbum
//
//  Created by 100 on 05.03.2021.
//

import UIKit
import AVKit
import Photos
import DKImagePickerController
import ImageUI
class ViewController: UIViewController,  UITabBarDelegate,UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
   
    
    let queue = OperationQueue()
    let imgManager = PHImageManager.default()
    var myvideoimage = [UIImage]()
    
    @IBOutlet weak var constHeight: NSLayoutConstraint!
    let pickerController = DKImagePickerController()

    var images = [UIImage]()

   

    @IBOutlet weak var plustabbar: UITabBarItem!
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var selectButtonoutlet: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var photovideocollectionView: UICollectionView!
    let picker = UIImagePickerController()
    var button : UIButton?
    var videoURL: NSURL?
    var selectedImage: UIImage?
       var secondbutton : UIButton?
       var thirdbutton : UIButton?
       var  blurEffectview : UIVisualEffectView?
    @available(iOS 11.0, *)
    func addButtons() {
//        if !UIAccessibility.isReduceTransparencyEnabled {

                                self.button  = UIButton()
                                self.secondbutton = UIButton()
                                self.thirdbutton  = UIButton()
                                self.view.addSubview(self.button!)
                                self.view.addSubview(self.secondbutton!)
                                self.view.addSubview(self.thirdbutton!)
                                
                                self.button?.translatesAutoresizingMaskIntoConstraints = false
                                self.secondbutton?.translatesAutoresizingMaskIntoConstraints = false
                                self.thirdbutton?.translatesAutoresizingMaskIntoConstraints = false
        self.button?.layer.cornerRadius = 10
        self.secondbutton?.layer.cornerRadius = 10
        self.thirdbutton?.layer.cornerRadius = 10
                                self.button?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
                                self.secondbutton?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
                                self.thirdbutton?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
                                
                                self.button?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
                                self.secondbutton?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
                                self.thirdbutton?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
                                
                                self.button?.bottomAnchor.constraint(equalTo: self.secondbutton!.topAnchor, constant: 0).isActive = true
                                self.secondbutton?.bottomAnchor.constraint(equalTo: self.thirdbutton!.topAnchor, constant: -10).isActive = true
                                self.thirdbutton?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
                                
                                self.button?.heightAnchor.constraint(equalToConstant: 57).isActive = true
                                self.secondbutton?.heightAnchor.constraint(equalToConstant: 57).isActive = true
                                self.thirdbutton?.heightAnchor.constraint(equalToConstant: 57).isActive = true
                                
                                self.secondbutton?.setTitle("Import photos or videos", for: .normal)
                                self.thirdbutton?.setTitle("Cancel", for: .normal)
                                self.secondbutton?.setTitleColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), for: .normal)
            self.thirdbutton?.setTitleColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), for: .normal)
                                self.secondbutton?.backgroundColor = #colorLiteral(red: 0.9496791959, green: 0.9635695815, blue: 1, alpha: 1)
                                self.thirdbutton?.backgroundColor = #colorLiteral(red: 0.9496791959, green: 0.9635695815, blue: 1, alpha: 1)
                                self.button?.backgroundColor = #colorLiteral(red: 0.9496791959, green: 0.9635695815, blue: 1, alpha: 1)
            self.button?.setTitleColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), for: .normal)
                                self.button?.setTitle("Take photo or video", for: .normal)

                                self.view.addSubview(self.button!)
                                self.view.addSubview(self.secondbutton!)
                                self.view.addSubview(self.thirdbutton!)
                               

                            
                                self.button?.addTarget(self, action: #selector(self.choosephoto), for: .touchUpInside)
        self.secondbutton?.addTarget(self, action: #selector(self.importphoto), for: .touchUpInside)
                                self.thirdbutton?.addTarget(self, action: #selector(self.dimissView), for: .touchUpInside)

    }
    @objc public var showsCancelButton = true
    @objc public var didCancel: (() -> Void)?

    
    @objc public var singleSelect = true
    public var defaultSelectedAssets: [DKAsset]?
    @objc func importphoto() {

        pickerController.showsCancelButton = true
        pickerController.deselectAll()
//        pickerController.singleSelect = true
        pickerController.allowSelectAll = true
        pickerController.allowMultipleTypes = true
        pickerController.sourceType = .both
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
              print("didSelectAssets")
                
                for asset in assets {
                    
                    if asset.type == .video {
                      
                        asset.fetchAVAsset(options: .none)  { (video, info) in
                            do {
                                if let vid = video {
                                let imagegen = AVAssetImageGenerator(asset: vid)
                                imagegen.appliesPreferredTrackTransform = true
                                let cgimage = try imagegen.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                                let thumbnail = UIImage(cgImage: cgimage)
                                    
                                self.selectedImage = thumbnail
                                    
                                    DispatchQueue.main.async {
                                    self.myvideoimage.append(thumbnail)
                                self.images.append(self.selectedImage!)
                                    self.reloadHeight()
                                    
                                    self.countLabel.isHidden = false
                                    self.countLabel.text = "Photos : \(self.images.count), Videos : \(self.myvideoimage.count)"
                                self.photovideocollectionView.reloadData()
                                    self.selectButtonoutlet.title = "Select"
                                    }
                                
                                }
                            } catch {
                                print("error generating thumbnail : \(error.localizedDescription)")
                            }
                            
                        }
                        
                    } else if asset.type == .photo {
                    asset.fetchOriginalImage { (image, info) in
                        guard let imagedata = image!.jpegData(compressionQuality: 0.9)else {
                            return
                        }
                   
                       
                           let thumbnail = UIImage(data: imagedata)
                        DispatchQueue.main.async {
                        self.images.append(thumbnail!)
                            self.reloadHeight()
                            
                            self.countLabel.isHidden = false
                        self.countLabel.text = "Photos : \(self.images.count), Videos : \(self.myvideoimage.count)"
                        self.photovideocollectionView.reloadData()
                        self.selectButtonoutlet.title = "Select"
                       
                        }
                    }
                    }
//                    self.reloadHeight()
//                    self.photovideocollectionView.reloadData()
                }
              print(assets)

                print("my images is \(self.images)")
                print("my images count is \(self.images.count)")
               
            }

            self.present(pickerController, animated: true, completion: nil)
        self.button?.removeFromSuperview()
        self.secondbutton?.removeFromSuperview()
        self.thirdbutton?.removeFromSuperview()
        
        
       }
       @objc func choosephoto() {
                if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("camera not available")
                } else {

                    DispatchQueue.main.async {
                        self.picker.delegate = self
                        self.picker.allowsEditing = false
                        self.picker.sourceType = .camera
                        self.picker.showsCameraControls = true
                        self.picker.mediaTypes = ["public.video", "public.image", "public.movie"]

                        self.present(self.picker, animated: true, completion: nil)
                    }
       }
          
       }
       @objc func dimissView () {
           print("dismiss view")
           
           self.button?.removeFromSuperview()
           self.secondbutton?.removeFromSuperview()
           self.thirdbutton?.removeFromSuperview()
//           self.blurEffectview?.removeFromSuperview()
       }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
        print("hello")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @objc public var UIDelegate: DKImagePickerControllerBaseUIDelegate!
    
    
    /// Forces deselect of previous selected image. allowSwipeToSelect will be ignored.
  
    @objc public var autoCloseOnSingleSelect = true
    @objc public var sourceType: DKImagePickerControllerSourceType = .both
    @objc public var allowMultipleTypes = true
    
    /// The maximum count of assets which the user will be able to select, a value of 0 means no limit.
    @objc public var maxSelectableCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        photovideocollectionView.delegate = self
        photovideocollectionView.dataSource = self
        
        self.photovideocollectionView.reloadData()
        
        
        countLabel.isHidden =
            true

        selectButtonoutlet.title = ""
       
    }
    func reloadHeight() {
            let height : CGFloat = self.photovideocollectionView.collectionViewLayout.collectionViewContentSize.height
            constHeight.constant = height
            self.view.setNeedsLayout()
        }
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
    }
    
  
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        button?.removeFromSuperview()
//         secondbutton?.removeFromSuperview()
//         thirdbutton?.removeFromSuperview()
//    }
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
       
        dismiss(animated: true, completion: nil)
       
       
    }
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let mediatype = info[UIImagePickerController.InfoKey.mediaType] as! String

        switch mediatype {
        case "public.image":
            self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            let imageurl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            self.images.append(self.selectedImage!)
           
          
            dismiss(animated: true, completion: nil)
            self.button?.removeFromSuperview()
            self.secondbutton?.removeFromSuperview()
            self.thirdbutton?.removeFromSuperview()
        case "public.video":
            self.videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            print("the video url is \(videoURL)")
            do {
                let asset = AVURLAsset(url: videoURL! as URL, options: nil)
                let imagegen = AVAssetImageGenerator(asset: asset)
                imagegen.appliesPreferredTrackTransform = true
                let cgimage = try imagegen.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgimage)
                self.selectedImage = thumbnail
                DispatchQueue.main.async {
                self.images.append(self.selectedImage!)
                }
              
            } catch {
                print("error generating thumbnail : \(error.localizedDescription)")
            }

            dismiss(animated: true, completion: nil)
            self.button?.removeFromSuperview()
            self.secondbutton?.removeFromSuperview()
            self.thirdbutton?.removeFromSuperview()
        case "public.movie" :
            self.videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            print("the video url is \(videoURL)")
            do {
                let asset = AVURLAsset(url: videoURL! as URL, options: nil)
                let imagegen = AVAssetImageGenerator(asset: asset)
                imagegen.appliesPreferredTrackTransform = true
                let cgimage = try imagegen.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgimage)
                self.selectedImage = thumbnail
                DispatchQueue.main.async {
                self.images.append(self.selectedImage!)
                    
                }
               
            } catch {
                print("error generating thumbnail : \(error.localizedDescription)")
            }
           
            dismiss(animated: true, completion: nil)
            self.button?.removeFromSuperview()
            self.secondbutton?.removeFromSuperview()
            self.thirdbutton?.removeFromSuperview()
        default :
            print("mismatched type :\(mediatype)")
        }

    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , IFBrowserViewControllerDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0 {
           emptyView.isHidden = true
        }

       
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoVideoCollectionViewCell
        
      
        cell.imageView.image = images[indexPath.row]
        cell.videoBtn.isHidden = true
        cell.starBtn.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hi")
        var ifimage = [IFImage]()
        let myimages = IFImage(image: images[indexPath.row])
//        for i in 0..<myimages.count {
        
        ifimage.append(myimages)
            print("ifimage.count is \(ifimage.count)")
//        }
//        let myimages = [IFImage(image: images)]
//        let viewController = IFBrowserViewController(images: [image], initialImageIndex: .random(in: [image].indices))
        let viewController = IFBrowserViewController(images: ifimage, initialImageIndex: .random(in: ifimage.indices))
//        viewController.configuration.actions = [.share, .delete]
        viewController.configuration.alwaysShowToolbar = true
        viewController.configuration.alwaysShowNavigationBar = true
     
        viewController.modalPresentationStyle = .fullScreen
////        viewController.delegate = self
//
////        viewController.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTap))
//        self.navigationController?.pushViewController(viewController, animated: true)
//        self.present(viewController, animated: true, completion: nil)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)

        
        
           print("hii")
//        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func closeButtonDidTap () {
       
    }
}
