//
//  ViewController.swift
//  suspicousAppFreeLogReader
//
//  Created by Jacob Jiang on 01/01/2018.
//  Copyright © 2018 Jacob Jiang. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var indicator: NSProgressIndicator!
    @IBOutlet var resultTextView: NSTextView!
    @IBOutlet weak var logFolderPathTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func selectFolder(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        if panel.runModal() != NSApplication.ModalResponse.OK {
            return
        }
        self.logFolderPathTextField.stringValue = (panel.urls.last?.absoluteString)!
        LogManager.shared.folderPath = self.logFolderPathTextField.stringValue.replacingOccurrences(of: "file://", with: "")
        indicator.startAnimation(nil)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            LogManager.shared.readLogFiles()
            DispatchQueue.main.async {
                self.indicator.stopAnimation(nil)
                self.resultTextView.string = LogManager.shared.result
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

