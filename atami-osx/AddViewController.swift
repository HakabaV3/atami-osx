//
//  AddViewController.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/12.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa
import AlamofireImage

class AddViewController: NSViewController {

    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var tagsField: NSTextField!

    @IBOutlet weak var addedURLField: NSTextField!
    @IBOutlet weak var previewImageView: NSImageView!

    private let disposeBag = DisposeBag()

    @IBAction func didClickAddButton(sender: AnyObject) {
        let url = self.urlField.stringValue
        let tagsString = self.tagsField.stringValue
        let tags = tagsString.componentsSeparatedByString(",")
        API.addImage(url: url, tags: tags)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] (image) in
                    self?.addedURLField.stringValue = image.proxiedUrl
                },
                onError: { (error) in
                    print(error)
                },
                onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(self.disposeBag)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlField.rx_text
            .asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(
                onNext: { [weak self] (text) in
                    if text.characters.count == 0 {
                        return
                    }
                    if let url = NSURL(string: text) {
                        self?.previewImageView.af_setImageWithURL(url)
                    }
                },
                onError: { (error) in
                    print(error)
                },
                onCompleted: nil,
                onDisposed: nil)
            .addDisposableTo(self.disposeBag)

    }

}
