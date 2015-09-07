//
//  RecordedAudio.swift
//  recordVoice
//
//  Created by masters3d on 11/25/14.
//  Copyright (c) 2014 masters3d. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
        
    }
    
}