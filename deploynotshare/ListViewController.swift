//
//  ListViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 26/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var labeltext = ["BIOLOGY","PYSICS","MATHS","ECOLOGY","BIOLOGY","PYSICS","MATHS","ECOLOGY"]
    let descriptiontext = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the printing and typesetting industry.","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the"]
    let timestamptext = ["01.04.15","01.04.15","01.04.15","01.04.15","01.04.15","01.04.15","01.04.15","01.04.15"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labeltext.count
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 2.0
//        
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ListTableViewCell
//        cell.Ttitle.text = labeltext[indexPath.row]
//        cell.Tdescription.text = descriptiontext[indexPath.row]
//        cell.Ttimestamp.text = timestamptext[indexPath.row]
        return cell
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
