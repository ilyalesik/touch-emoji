//
//  AppDelegate.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Cocoa

@available(OSX 10.12.2, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // dic array containing the list of apps which should have the permanent emoji bar:
    static var emojisForApp: [[String: String]] = []
    
    // the Touch Bar
    let touchBar = TouchBarController()
    
    // we check for file changed in the preferences files containing the latest used emojis
    // starting in 10.13, most frequent emojis are stored in the EmojiPreferences.plist file: it also contains the number of times each emoji was used
    let fileWatcher = SwiftFSWatcher([NSHomeDirectory()+"/Library/Preferences/com.apple.EmojiPreferences.plist", NSHomeDirectory()+"/Library/Preferences/com.apple.CharacterPicker.plist"])
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        TouchBarController.shared.setupControlStripPresence()
        
        // set the frequently used emojis:
        Emojis.arrayEmojis = Emojis.getAllEmojis()
        
        // we show the permanent emoji Touch Bar:
        NSTouchBar.presentSystemModalFunctionBar(touchBar.systemModalTouchBar, systemTrayItemIdentifier: touchBar.emojiSystemModal)

        // in case of a preferences files change:
        fileWatcher.watch { changeEvents in
            for _ in changeEvents {
                // update array containing recently used emojis:
                Emojis.arrayEmojis = Emojis.getAllEmojis()
                
                // reload the data of the Touch Bar:
                self.touchBar.scrubber.reloadData()
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // we close the app if the window gets closed:
        return true
    }
}

