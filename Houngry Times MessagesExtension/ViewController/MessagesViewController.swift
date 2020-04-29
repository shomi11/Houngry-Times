//
//  MessagesViewController.swift
//  Houngry Times MessagesExtension
//
//  Created by Malovic, Milos on 4/27/20.
//  Copyright © 2020 Malovic, Milos. All rights reserved.
//

import UIKit
import Messages
import MapKit
import CoreLocation

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: Properties
    
    var restaurant: Restaurant?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        // will become active is fired every time when message controller delegate is fired
        // after ther based on restaurant values it deside what controller to present next
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        // will transition is called every time when presentation style is changed
        removeChildControllers()
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        guard let conversation = activeConversation else { print("Expected an active converstation")
            return
        }
        presentViewController(for: conversation, with: presentationStyle)
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    // MARK: Function's
    
    // remove all childre when presentation style is changed and some controller is instantiated
    private func removeChildControllers() {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        // Remove any child view controllers that have been presented.
        removeChildControllers()
        
        let controller: UIViewController
        
        // if presentation style is compact instantiate map every time
        if presentationStyle == .compact {
            controller = instantiateMapViewController()
        } else {
            
            // if set for chossing date for launch, means user did choose restaurant and restauant have a name, phone number and address then present info so user can choose a date
            if restaurant!.isSet {
                controller = instantiateInfoViewController(with: restaurant!)
                
                // means that user did select date, and restaurant now have all properties filled, now is ready to create a message proposal for food place, receipent will see this view controller
            } else if restaurant!.isFullSet {
                controller = instantiateProposalViewController(with: restaurant!)
                
                // in every other case instantiate map again
            } else {
                controller = instantiateMapViewController()
            }
        }
        
        addChild(controller)
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        controller.didMove(toParent: self)
    }
    
    private func instantiateInfoViewController(with restaurant: Restaurant) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "InfioViewController")
            as? InfoViewController
            else { fatalError("Unable to instantiate an from the storyboard") }
        controller.restaurant = restaurant
        controller.delegate = self
        return controller
    }
    
    private func instantiateProposalViewController(with restaurant: Restaurant) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ProposalViewController")
            as? ProposalViewController
            else { fatalError("Unable to instantiate an from the storyboard") }
        controller.restaurant = restaurant
        controller.delegate = self
        return controller
    }
    
    private func instantiateMapViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController")
            as? MapViewController
            else { fatalError("Unable to instantiate an from the storyboard") }
        controller.mapDelegate = self
        controller.infoDelegate = self
        return controller
    }
    
    func createMessage(with restaurant: Restaurant) {
       
        // asign restaurant from info view controller so it have all properrties that needs for user to send proposal to reciepent
        self.restaurant = restaurant
      
        // 1: return the extension to compact mode, it will fire will become active with present func inside
        requestPresentationStyle(.compact)
        
        // 2: do a quick sanity check to make sure we have a conversation to work with
        guard let conversation = activeConversation else { print("returned")
            return
        }
        
        // 3: convert restaurant properties into URLQueryItem objects
        var components = URLComponents()
        var items = [URLQueryItem]()
        
        let dateItem = URLQueryItem(name: "date-", value: restaurant.resDate?.toString())
        items.append(dateItem)
        
        let nameItem = URLQueryItem(name: "name-", value: restaurant.name)
        items.append(nameItem)
        
        let addressItem = URLQueryItem(name: "address-", value: restaurant.address)
        items.append(addressItem)
        
        components.queryItems = items
        
        // 4: use the existing session or create a new one
        let session = conversation.selectedMessage?.session ?? MSSession()
        
        // 5: create a new message from the session and assign it the URL we created from our dates and votes
        let message = MSMessage(session: session)
        message.url = components.url
        
        // 6: create a blank, default message layout
        let layout = MSMessageTemplateLayout()
        layout.caption = "reservation"
        message.layout = layout
        
        // 7: insert it into the conversation with the change message "Votes added"
        conversation.insert(message) { error in
            if let error = error {
                print(error.localizedDescription)
                self.presentAlertController(withTitle: "Something went wrong", message: "could not send message", textField: nil, actions: (title: "OK", style: .default, handler: nil))
            }
        }
    }
    
    func sendConfirmationMessage() {
        
        // set restaurant to nil again
        self.restaurant = nil
        
        requestPresentationStyle(.compact)
        
        guard let conversation = activeConversation else { print("returned")
            return
        }
        let session = conversation.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: session)
        
        let layout = MSMessageTemplateLayout()
        layout.caption = "Confirmed"
        
        // set image that will be sent if user confirms proposal
        let image = UIImage(named: "confrimation.png")
        layout.image = image
        
        message.layout = layout
        
        conversation.insert(message) { error in
            if let error = error {
                print("final error", error)
            }
        }
    }
}

// MARK: MapDelegate
// Fired when user choose restaurant an map, request for expanded mod that fires become active and search what controller in expanded mode to present based on restaurant properties, in this case info controller
extension MessagesViewController: MapDelegate {
    func mapControllerDidChooseRestaurant(_ controller: MapViewController, restaurant: Restaurant) {
        self.restaurant = restaurant
        requestPresentationStyle(.expanded)
    }
}
