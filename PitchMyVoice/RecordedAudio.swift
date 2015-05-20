//
//  RecordedAudio.swift
//  PitchMyVoice
//
//  Created by Aras Senova on 2015-05-17.
//  Copyright (c) 2015 Aras Senova. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    let filePathUrl: NSURL
    let title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
