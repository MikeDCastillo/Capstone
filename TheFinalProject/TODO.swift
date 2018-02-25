//
//  TODO.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 12/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

/*
 
 *blocking the content*
 
 option 3 - on each Submission have an [User]
 
 ---> not allow profanity
 

(X) 1. change the model. Submission needs to have a flag count: Int
 
 2. Put flag button in UI. (press the button, count is upped by 1)
    Create func that ups the Submission flagCount
 optional - alert controller for flagging button in UI
 optional - first time someone flags content, the default is hidden
 
    hide the button if the user has already voted on meme
    show the button if there is a meme and currentSubmission.flagcount <= 0
 
 
 3. user setting to display objectionable content (show objectionable content)
    Add cell into User setting to switch on the displayed content
 
 4. filter [Submission] that have flagCount > 0, based on user setting (preference has to be persisted to Firebase)
 
 5. update screenshots
 
 6. Submit here foo
 
 BONUS - Handle meme API with FirBaseData
 BONUS - Landscape mode
 
 Extra BONUS - draw Users attention to create meme if no meme is created
 Extra BONUS - get rid of buttons to Vote and use Xib/cell Emojis to vote
 Extra BONUS -
 
 */
