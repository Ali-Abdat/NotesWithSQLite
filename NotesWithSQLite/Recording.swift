//
//  Recording.swift
//  NotesWithSQLite
//
//  Created by Ali Abdat on 12/11/17.
//  Copyright © 2017 Ali Abdat. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class Sound
{
    var SoundPlayer : AVAudioPlayer = AVAudioPlayer()
    var Record : AVAudioRecorder = AVAudioRecorder()
    var filename = "audio.m4a"
    init() {
    }
    func SetupRecord() {
        let RecordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.0,] as [String : Any]
        do
        {
            Record = try AVAudioRecorder(url: GetFileURL(), settings: RecordSettings)
            //Record.delegate = self
            Record.prepareToRecord()
        }
        catch
        {
            print(error)
        }

    }
    func GetCascheDirectory() -> String {
        let paths =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    func GetFileURL() -> URL
    {
        let path = GetCascheDirectory().appending(filename)
        let filepath = URL(fileURLWithPath: path)
        return filepath
    }
   
}
