//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages : [Message] = []
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil),
                           forCellReuseIdentifier: K.cellIdentifier )
        
        loadMessages()
        
    }
    
    func loadMessages()  {
        
        messages = []
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.messages = []
                
                if let e = error {
                    print("There was an issue retrieving data from firestore. \(e)")
                }else{
                    
                    if let snapshotDocument = querySnapshot?.documents {
                        
                        for doc in snapshotDocument {
                            
                            let data =  doc.data()
                            
                            if let messageSender = data[K.FStore.senderField] as? String
                               , let messageBody = data[K.FStore.bodyField] as? String  {
                                
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                    self.tableView.reloadData()
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text , let messaageSender =
            Auth.auth().currentUser?.email {
            
            db.collection(K.FStore.collectionName).addDocument(data: [
                
                K.FStore.senderField : messaageSender ,
                K.FStore.bodyField : messageBody ,
                K.FStore.dateField : Date().timeIntervalSince1970
                
            ]) { (Error) in
                
                if let e = Error {
                    print("there was an error to save data to firestore , \(e)")
                }else{
                    
                    print("Successfully saved data.")
                    
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
                
            }
            
        }
        
        messageTextfield.text = ""
        
    }
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier , for: indexPath) as! MessageCell
        cell.label?.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            
        }else{
            
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        return cell
        
    }
    
}
//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

