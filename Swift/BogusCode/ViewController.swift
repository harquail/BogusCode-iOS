//
//  ViewController.swift
//  BogusCode
//
//  Created by Johnny BlockingCall on 2/11/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//

import UIKit

let kOneConstant = 1

class MasterViewController: UITableViewController, NSURLConnectionDelegate {
    
    var objects:[AnyObject]?
    var pictures:[AnyObject]?
    var tableview:UITableView?
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(frame: self.view.bounds)
        
        if(self.objects != nil && self.objects!.count > 0 && self.objects!.count > indexPath.row){
            let object:NSObject = self.objects![indexPath.row] as! NSObject
            cell.textLabel!.text = object.valueForKey("name") as! String
            let url = object.valueForKey("pictures")!.valueForKey("sizes")!.objectAtIndex(0).valueForKey("link") as! NSString
            let image = UIImage(data: NSData(contentsOfURL: NSURL(string: url as String)!)!)
            cell.imageView!.image = image
        }
        else{
            cell.textLabel!.text = "no more videos, scroll up..."
        }
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.vimeo.com/channels/staffpicks/videos")!)
        request.setValue("bearer b8e31bd89ba1ee093dc6ab0f863db1bd", forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "GET"
        let connection = NSURLConnection(request: request, delegate: nil)
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let response = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let responseString = NSString(CString: UnsafePointer<Int8>(response.bytes), encoding: NSUTF8StringEncoding)
        let resDict = try! NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions(rawValue: 0))
        self.objects = resDict.objectForKey("data") as! [AnyObject]
        
        print("found \(resDict.count) objects")
        
        self.tableView?.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kOneConstant
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableview = tableView
        
        return 1000
    }
    
    override func viewDidLoad() {
        self.objects = NSMutableArray(capacity: 1000) as [AnyObject]
        self.pictures = NSMutableArray(capacity: 1000) as [AnyObject]
        
        self.navigationItem.title = "Vimeo Staf Pics"
    }
    
}

