####Note: It appears my API Key is no longer valid, so the application no longer grabs the definitions (i.e. the app no longer works). I don't even use the app for personal use, so I won't be maintaining it. I've also unscheduled the task that automatically creates quizzes. Onward and upward!

#Wordsmith
Wordsmith ([getwordsmith.com](http://www.getwordsmith.com)) is a free service built with Ruby on Rails that sends you daily vocabulary quizzes via email. Simply reply to the email with your answers and we'll keep track of your progress.

###Features
- Choose the exact definitions on which you want to be quizzed
- Choose the number of questions per quiz and the time of day you want it to be emailed to you
- Reply to the quizzes over email
- Quizzes get progressively more difficult as you consistently answer questions correctly

###How it works
Each word has an associated Difficulty and Level, starting at Difficulty 1 Level 1 (henceforth D1L1). Answer a question correctly on a quiz, and it moves up a level (to D1L2). Answer a question incorrectly and it falls back down to Level 1 of that Difficulty (e.g. the word 'terpsichorean' is currently on D2L3, but you get it wrong, it will fall back to D2L1). Answer the word correctly three times and it moves to the next Difficulty (D2L1). There are three quiz styles corresponding to each Difficulty.

- Difficulty 1: Multiple choice - x questions, x words in the wordbank
- Difficulty 2: Multiple choice - x questions, 2x words in the wordbank
- Difficulty 3: Fill in the blank - no wordbank
