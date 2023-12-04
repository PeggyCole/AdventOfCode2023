
define variable vcLine           as character no-undo.
define variable vcWinningNumbers as character no-undo.
define variable vcScratchCard    as character no-undo.
define variable viCardPoints     as integer   no-undo.
define variable viSum            as integer   no-undo.
define variable viScratchNumber  as integer   no-undo.

input from value(search("day04\day04_input.txt")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
  
  assign
    viCardPoints     = 0
    vcWinningNumbers = ""
    vcScratchCard    = "".

  vcWinningNumbers = trim(entry(1, entry(2, vcLIne, ":"), "|")).
  vcScratchCard = trim(entry(2, entry(2, vcLIne, ":"), "|")).
  
  do viScratchNumber = 1 to num-entries(vcScratchCard, " "):
    if entry(viScratchNumber, vcScratchCard, " ") = "" then next.
    
    if lookup (entry(viScratchNumber, vcScratchCard, " "), vcWinningNumbers, " ") > 0 then do:
      if viCardPoints = 0 then
        viCardPoints = 1.
      else
        viCardPoints = viCardPoints * 2.  
      
    end.
  end.
  
  viSum = viSum + viCardPoints.
end.  

message viSum
  view-as alert-box.
  
  /*
  
  ---------------------------
Message (Press HELP to view stack trace)
---------------------------
23028
---------------------------
OK   Help   
---------------------------
  
  */