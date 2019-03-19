//
//  TouchBarController.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Foundation

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("com.toxblh.mtmr.controlStrip")
}

@available(OSX 10.12.2, *)
class TouchBarController: NSObject, NSTouchBarDelegate {
    
    var showControlStripState: Bool {
        get {
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "com.toxblh.mtmr.settings.showControlStrip")
        }
    }
    
    // the identifiers for the Touch Bar modal and items:
    let emojiSystemModal = NSTouchBarItemIdentifier("in.lor.EmojiSystemModal")
    let emojiScrubberIdentifier = NSTouchBarItemIdentifier("in.lor.EmojiScrubber")
    let emojiButtonIdentifier = NSTouchBarItemIdentifier("in.lor.EmojiButton")
    
    // the scrubber we use to display the emojis:
    var scrubber = NSScrubber()
    
    // we keep track of a single Touch Bar object:
    private var singleSystemModalTouchBar: NSTouchBar?
    
    var systemModalTouchBar: NSTouchBar? {
        // if the Touch Bar object is not set:
        if (singleSystemModalTouchBar == nil) {
                let touchBar = NSTouchBar()
                // the Touch Bar will contain the scrubber and the button:
                touchBar.defaultItemIdentifiers = [emojiScrubberIdentifier,emojiButtonIdentifier]
                touchBar.delegate = self
                singleSystemModalTouchBar = touchBar
        }
        return singleSystemModalTouchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        // the Touch Bar is initializing:
        if (identifier == emojiScrubberIdentifier) {
            
            // setting up the emoji Scrubber:
            let scrubberItem: NSCustomTouchBarItem
            scrubberItem = Scrubber(identifier: identifier)
            scrubber = scrubberItem.view as! NSScrubber
            
            return scrubberItem
            
        } else {
            
            return nil
        }
    }
    
    static let shared = TouchBarController()
    
    var touchBar = NSTouchBar()
    
    func setupControlStripPresence() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        let item = NSCustomTouchBarItem(identifier: .controlStripItem)
        item.view = NSButton(image: #imageLiteral(resourceName: "Strip"), target: self, action: #selector(presentTouchBar))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
    }
    
    func updateControlStripPresence() {
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
    }
    
    @objc private func presentTouchBar() {
            updateControlStripPresence()
            presentSystemModal(self.systemModalTouchBar, systemTrayItemIdentifier: .controlStripItem)
    }

}
