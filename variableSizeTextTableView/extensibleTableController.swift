//
//  extensibleTableController.swift
//  variableSizeTextTableView
//
//  Created by Marcus Chandler on 13/09/2016.
//  Copyright © 2016 Marcus Chandler. All rights reserved.
//

class extensibleTableController : UITableViewController, UITextViewDelegate {
    
    var data : [String]!
    var heights : [CGFloat] = Array(repeating: 30, count: 100)
    let paragraphStyle : NSParagraphStyle = {
        let pS : NSParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSParagraphStyle
        return pS
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.data = Array(repeating: "", count: 100)
        self.tableView = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: self.view.frame.size.width / 4, height: self.view.frame.height / 2)))
        self.tableView.backgroundColor = UIColor.red
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) was tapped!")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return heights[(indexPath as NSIndexPath).row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.tableView.frame.width, height: self.heights[(indexPath as NSIndexPath).row]))
        
        let stringValue : String? = {
            if self.data[(indexPath as NSIndexPath).row] != "" {
                return self.data[(indexPath as NSIndexPath).row]
            }
            return nil
        }()
        
        // Clean down
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        let textView : UITextView = {
            let tV : UITextView = UITextView()
            tV.backgroundColor = UIColor.black
            tV.textColor = UIColor.white
            tV.text = stringValue != nil ? stringValue! : ""
            tV.delegate = self
            tV.tag = (indexPath as NSIndexPath).row
            tV.layer.borderColor = UIColor.white.cgColor
            tV.layer.borderWidth = 1.0
            tV.frame = CGRect(origin: CGPoint(x: 0, y: 1), size: cell.frame.insetBy(dx: 10, dy: 1).size)
            return tV
        }()
        
        let numberLabel : UILabel = {
            let nL : UILabel = UILabel()
            nL.textColor = UIColor.white
            nL.text = String((indexPath as NSIndexPath).row)
            nL.frame = CGRect(origin: CGPoint(x: cell.frame.width - 20, y: 1), size: CGSize(width: 20, height: cell.frame.height - 2))
            return nL
        }()
    
        cell.addSubview(textView)
        cell.addSubview(numberLabel)
        return cell
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.updateLayout(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var textFrame : CGRect = textView.frame
        let newHeight : CGFloat = ceil(textView.contentSize.height)
        if newHeight - textFrame.height > 0 {
            textFrame.size.height = ceil(textView.contentSize.height)
            textView.frame = textFrame
            textView.setContentOffset(CGPoint(x: 0, y: 5), animated: false)
            self.updateLayout(textView)
        }
        
        textView.selectedRange = NSRange(location: textView.text.characters.count, length: 0)
        textView.becomeFirstResponder()
        return true
    }
    
    
    func updateLayout(_ forTextView: UITextView) -> Void {
        guard forTextView.tag < self.data.count else { return }
                
        self.data[forTextView.tag] = forTextView.text
        
        let newHeight : CGFloat = forTextView.frame.height
        let oldHeight : CGFloat = self.tableView.cellForRow(at: IndexPath(row: forTextView.tag, section: 0))!.frame.height
        
        self.heights[forTextView.tag] = newHeight + 2
        UIView.animate(withDuration: 0.25, animations: { 
            for cell in self.tableView.visibleCells {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    if (indexPath as NSIndexPath).row > forTextView.tag {
                        cell.frame = CGRect(origin: CGPoint(x: cell.frame.origin.x, y: cell.frame.origin.y + forTextView.frame.height + 2 - oldHeight), size: CGSize(width: cell.frame.width, height: self.heights[(indexPath as NSIndexPath).row]))
                    }
                    else if (indexPath as NSIndexPath).row == forTextView.tag
                    {
                        cell.frame = CGRect(origin: cell.frame.origin, size: CGSize(width: cell.frame.width, height: self.heights[(indexPath as NSIndexPath).row]))
                    }
                }
            }
        }) 
    }
  
}
