define variable vcLine           as character no-undo.
define variable vcWinningNumbers as character no-undo.
define variable vcScratchCard    as character no-undo.
define variable viSum            as integer   no-undo.
define variable viScratchNumber  as integer   no-undo.

define variable viCopies         as integer   no-undo extent 10000.
define variable viGameId         as integer   no-undo.
define variable viWins           as integer   no-undo.

input from value(search("day04\day04_input.txt")).

debugger:initiate().
debugger:set-break().

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
  
  assign
    vcWinningNumbers = ""
    vcScratchCard    = ""
    viGameId         = 0
    viWins           = 0.

  viGameId = int(trim(replace(entry(1, vcLine, ":"), "Card", ""))).
  vcWinningNumbers = trim(entry(1, entry(2, vcLIne, ":"), "|")).
  vcScratchCard = trim(entry(2, entry(2, vcLIne, ":"), "|")).
  
  do viScratchNumber = 1 to num-entries(vcScratchCard, " "):
    if entry(viScratchNumber, vcScratchCard, " ") = "" then next.
    
    if lookup (entry(viScratchNumber, vcScratchCard, " "), vcWinningNumbers, " ") > 0 then 
    do:
      assign
        viWins = viWins + 1  
        viCopies[viGameId + viWins] = viCopies[viGameId + viWins] + (1 + viCopies[viGameId]).  
      
    end.
  end.
  
  viSum = viSum + 1 + viCopies[viGameId].
end.  

message viSum
  view-as alert-box.
  
  /*
  
---------------------------
Message (Press HELP to view stack trace)
---------------------------
9236992
---------------------------
OK   Help   
---------------------------

  
  */