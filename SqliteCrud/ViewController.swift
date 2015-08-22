//
//  ViewController.swift
//  SqliteCrud
//
//  Created by Kristian Secor on 4/1/15.
//  Copyright (c) 2015 Kristian Secor. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
  
    
    var databasePath = NSString()
    
 
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var position: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the path to the db
        //File Manager
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)
        println(dirPaths)
        let docsDir = dirPaths[0] as String
        databasePath = docsDir.stringByAppendingPathComponent("contacts.db")
        if !filemgr.fileExistsAtPath(databasePath){
            //if no, we need to create the db
            let contactDB = FMDatabase(path:databasePath)
            if contactDB == nil  {
                println("Error: \(contactDB.lastErrorMessage())")
            }
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT,PHONE TEXT,EMAIL TEXT,POSITION TEXT )"
            if !contactDB.executeStatements(sql_stmt) {
                println("Error: \(contactDB.lastErrorMessage())")
                }
            contactDB.close()
            }//closes out the condition if !filemgr
            else
            {
        println("Error: \(contactDB.lastErrorMessage())")
            }
            
        }

        
        //contactDb.open
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData(sender: AnyObject) {
        let contactDB = FMDatabase(path:databasePath)
        if  contactDB.open() {
        let insertSql = "Insert into CONTACTS (NAME,PHONE,EMAIL,POSITION) VALUES ('\(name.text)','\(phone.text)','\(email.text)','\(position.text)')"
        let result = contactDB.executeUpdate(insertSql, withArgumentsInArray:nil)
            if !result {
                name.text = "Failed to add Contact"
                println("Error: \(contactDB.lastErrorMessage())")
                phone.text = ""
                email.text = ""
                position.text = ""
            }
            else
            {
                name.text = "Contact Added"
                phone.text = ""
                email.text = ""
                position.text = ""
            }      
            
        }//closed if contact open
        else
        {
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }//closes method

    @IBAction func searchContact(sender: AnyObject) {
        let contactDB = FMDatabase(path:databasePath)
        if  contactDB.open() {
            let searchSql = "Select NAME,PHONE,EMAIL,POSITION from CONTACTS where NAME = '\(name.text)'"
            let results:FMResultSet? = contactDB.executeQuery(searchSql, withArgumentsInArray:nil)
            if results?.next() == true {
                phone.text = results?.stringForColumn("PHONE")
                email.text = results?.stringForColumn("EMAIL")
                position.text = results?.stringForColumn("POSITION")

            }
            else
            {
                phone.text = ""
                email.text = ""
                position.text = ""
            }
            contactDB.close()
        }

        }
   
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    
    
}

