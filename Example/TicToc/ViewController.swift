//
//  ViewController.swift
//  TicToc
//
//  Created by terrordrummer on 04/23/2018.
//  Copyright (c) 2018 terrordrummer. All rights reserved.
//

import UIKit
import TicToc

class ViewController: UIViewController {

    @IBOutlet weak var backgroundOperationButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var resultLabel: UILabel!
    
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    let tictoc = TicToc()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func startBackgroundOperation(_ sender: UIButton) {
        // prepare the UI
        backgroundOperationButton.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: backgroundOperationButton.bounds.midX,
                                           y: backgroundOperationButton.bounds.midY)
        backgroundOperationButton.isEnabled = false
        activityIndicator.startAnimating()
        progressView.alpha = 1
        progressView.progress = 0
        resultLabel.text = ""
        
        // start the background job
        startBackgroundOperation()
    }
    @IBAction func measureClosure(_ sender: UIButton) {
        // sync code executed immediatly
        TicToc.measure(label: "operation executed in") {
            performOperations()
        }
        NSLog("measurement done")
        showCompletedAlert()
    }
    
    @IBAction func measureClosureWithCompletion(_ sender: UIButton) {
        TicToc.measure(label: "executed executed in") { (completion) in
            // operation is executed asynchronously and completion is called at the end
            DispatchQueue.main.async {
                self.performOperations()
                completion()
                self.showCompletedAlert()
            }
        }
        NSLog("measurement started")
    }
    // MARK: - Private
    private func initUI() {
        progressView.alpha = 0
    }
    
    private func startBackgroundOperation() {
        self.tictoc.tic()
        DispatchQueue.global(qos: .background).async {
            // operation consist in several float multiplications between random numbers
            var progress = 0
            for i in 0..<10000000 {
                _ = Float(arc4random()) * Float(arc4random())
                // update the progress view at each percentage step
                let perc = i / 100000
                if perc != progress {
                    progress = perc
                    DispatchQueue.main.async {
                        self.progressView.progress = Float(progress) / 100.0
                    }
                }
            }
            DispatchQueue.main.async {
                self.stopBackgroundOperation()
            }
        }
    }

    private func stopBackgroundOperation() {
        progressView.alpha = 0
        activityIndicator.removeFromSuperview()
        backgroundOperationButton.isEnabled = true
        
        resultLabel.text = String(format: "Operation executed in %.3f sec", tictoc.toc())
    }
    
    private func performOperations() {
        for _ in 0..<10000 {
            _ = Float(arc4random()) * Float(arc4random())
        }
    }
    
    private func showCompletedAlert() {
        let alert = UIAlertController(title: "Operation Done", message: "Check your console to get the elapsed time logs", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

