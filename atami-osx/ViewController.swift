//
//  ViewController.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/11.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa
import AlamofireImage

class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var keywordField: NSTextField!

    private let disposeBag = DisposeBag()
    private var images: [EntityImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.registerNib(NSNib(nibNamed: "ImageCollectionItem", bundle: NSBundle.mainBundle())!, forItemWithIdentifier: "ImageCollectionItem")

        self.keywordField.rx_text
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map({ (text) -> Observable<[EntityImage]> in
                if text.characters.count == 0 {
                    return Observable.just([])
                }
                print("search: \(text)")
                return API.search(keyword: text)
            })
            .switchLatest()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] (images) in
                    print("result: \(images)")
                    self?.images = images
                    self?.collectionView.reloadData()
                },
                onError: { (error) in
                    print(error)
                },
                onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(self.disposeBag)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSCollectionViewDataSource {
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

extension ViewController: NSCollectionViewDelegate {
    func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        let image = self.images[indexPath.item]
        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.declareTypes([NSStringPboardType], owner: nil)
        pasteBoard.setString(image.proxiedUrl, forType: NSStringPboardType)
    }
}
