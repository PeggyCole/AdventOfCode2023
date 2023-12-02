  
define variable viMaxBlue       as integer   no-undo.
define variable viMaxRed        as integer   no-undo.
define variable viMaxGreen      as integer   no-undo.    
define variable viSum           as integer   no-undo.      
define variable viCounter       as integer   no-undo.      
define variable vcShow          as character no-undo.
define variable vcLine          as character no-undo.
define variable vcInLine        as character no-undo.
define variable viCounterInline as integer   no-undo.      
    
input from value(search("day02\day02_input.txt")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
    
  if vcLIne = "" then leave.    
    
  assign
    viMaxBlue  = 0
    viMaxRed   = 0
    viMaxGreen = 0.
    
  do viCounter = 1 to num-entries(entry(2, vcLine, ":":u), ";":u):
    vcShow = trim(entry(viCounter, entry(2, vcLine, ":":u), ";":u)).
      
    do viCounterInline = 1 to num-entries(vcShow, ","):
      vcInline = trim(entry(viCounterInline, vcShow, ",")).
        
      case trim(entry(2, vcInLine, " ")):
        when "blue"  then viMaxBlue = max(int(trim(entry(1, vcInLine, " "))), viMaxBlue).
        when "red"   then viMaxRed = max(int(trim(entry(1, vcInLine, " "))), viMaxRed).
        when "green" then viMaxGreen = max(int(trim(entry(1, vcInLine, " "))), viMaxGreen).
      end case.             
    end.        
  end.
    
  viSum = viSum + (viMaxBlue * viMaxRed * viMaxGreen).
    
end.  
input close.

message viSum view-as alert-box info.
