//
//  ViewController.swift
//  variableSizeTextTableView
//
//  Created by Marcus Chandler on 13/09/2016.
//  Copyright © 2016 Marcus Chandler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var tVController :extensibleTableController!
    var tapGestureRecognizer : UITapGestureRecognizer!
    var label : UILabel!
    
    
    let transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tVController = extensibleTableController(style: UITableViewStyle.plain)
        self.view.addSubview(self.tVController.tableView)
        
        self.tapGestureRecognizer = UITapGestureRecognizer()
        self.tapGestureRecognizer.delegate = self
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.toggleLabel))
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.tVController.tableView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
    
    func toggleLabel() -> Void {
        if self.label == nil {
            print("Creating label")
            self.label = UILabel(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: 20), size: CGSize(width: 100, height: 20)))
            self.label.text = "Hello World!"
            self.label.textColor = UIColor.red
            self.label.transform = self.transform
        }
        
        if self.label.isDescendant(of: self.view) {
            print("Removing label")
            self.label.removeFromSuperview()
        }
        else
        {
            print("Adding label")
            self.view.addSubview(self.label)
        }
    }
}
