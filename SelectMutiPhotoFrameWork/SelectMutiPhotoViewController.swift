//
//  ViewController.swift
//  SelectMutiPhoto
//
//  Created by tony on 2017/9/8.
//  Copyright © 2017年 tony. All rights reserved.
//

import UIKit
import Photos
public protocol SelectMutiPhotoDelegate {
    func selectMutiPhoto(_ images : Array<UIImage>)
}
class SelectMutiPhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var col: UICollectionView!
    var selectPhotosTag = Array<Int>()
    var allPhotos = PHFetchResult<PHAsset>()
    var delegate : SelectMutiPhotoDelegate?
    @IBAction func pressDoneAction(_ sender: Any) {
        var selectPhotos = Array<UIImage>()
        for i in selectPhotosTag{
            selectPhotos.append(getAssetThumbnail(asset: allPhotos[i]))
        }
        self.dismiss(animated: true){
            self.delegate?.selectMutiPhoto(selectPhotos)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                let sortOrder = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.sortDescriptors = sortOrder
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Found \(self.allPhotos.count) images")
                DispatchQueue.main.async {
                    self.col.dataSource = self
                    self.col.delegate = self
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let boardwidth = (collectionView.frame.width - 20 ) / 3
        return CGSize(width: boardwidth, height: boardwidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimpleCell
        cell.img.layer.borderWidth = 0
        cell.img.layer.borderColor = UIColor.red.cgColor
        cell.sortLbl.text = ""
        
        cell.img.image = getAssetThumbnail(asset: allPhotos[indexPath.row])
        if selectPhotosTag.contains(indexPath.row){
            if let select = selectPhotosTag.index(of: indexPath.row){
                cell.sortLbl.text = (select + 1).description
            }
            cell.img.layer.borderWidth = 5
            cell.img.layer.borderColor = UIColor.red.cgColor
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectPhotosTag.contains(indexPath.row){
            if let select = selectPhotosTag.index(of: indexPath.row){
                selectPhotosTag.remove(at: select)
            }
        }else{
            selectPhotosTag.append(indexPath.row)
        }
        self.col.reloadData()
    }
}

class SimpleCell : UICollectionViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sortLbl: UILabel!
}
