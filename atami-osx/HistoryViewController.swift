//
//  HistoryViewController.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/12.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa
import AlamofireImage

class HistoryViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    private let disposeBag = DisposeBag()
    private var images: [EntityImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.registerNib(NSNib(nibNamed: "ImageCollectionItem", bundle: NSBundle.mainBundle())!, forItemWithIdentifier: "ImageCollectionItem")
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        if let images = NSUserDefaults.standardUserDefaults().arrayForKey(Const.HistoryKey) as? [[String: String]] {
            self.images = images.map({ EntityImage.fromDictionary($0) })
            self.collectionView.reloadData()
        }
    }

    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension HistoryViewController: NSCollectionViewDataSource {
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItemWithIdentifier("ImageCollectionItem", forIndexPath: indexPath)
        guard let imageItem = item as? ImageCollectionItem else { return item }

        let image = self.images[indexPath.item]
        imageItem.sampleImageView?.af_setImageWithURL(NSURL(string: image.proxiedUrl)!, placeholderImage: NSImage(named: "placeholder"))
        return imageItem
    }
}

extension HistoryViewController: NSCollectionViewDelegate {
    func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        let image = self.images[indexPath.item]
        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.declareTypes([NSStringPboardType], owner: nil)
        pasteBoard.setString(image.proxiedUrl, forType: NSStringPboardType)

        // Save history
        if var images = NSUserDefaults.standardUserDefaults().arrayForKey(Const.HistoryKey) as? [[String: String]] {
            images.insert(image.toDictionary(), atIndex: 0)
            NSUserDefaults.standardUserDefaults().setObject(images, forKey: Const.HistoryKey)
            NSUserDefaults.standardUserDefaults().synchronize()

            self.collectionView.reloadData()
        }
    }
}
