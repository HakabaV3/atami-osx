//
//  SettingViewController.swift
//  atami-osx
//
//  Created by Jin Sasaki on 2016/06/12.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Cocoa

class SettingViewController: NSViewController {

    @IBOutlet weak var historyTextField: NSTextField!

    @IBAction func didClickResetHistory(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject([], forKey: Const.HistoryKey)
        NSUserDefaults.standardUserDefaults().synchronize()

        self.updateHistoryLabel()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateHistoryLabel()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        self.updateHistoryLabel()
    }

    private func updateHistoryLabel() {
        let histories = NSUserDefaults.standardUserDefaults().arrayForKey(Const.HistoryKey) as? [[String: String]] ?? []
        self.historyTextField.stringValue = "\(histories.count) histories."
    }
}
