  
define variable viMaxBlue       as integer   no-undo initial 14.
define variable viMaxRed        as integer   no-undo initial 12.
define variable viMaxGreen      as integer   no-undo initial 13.    
define variable viSum           as integer   no-undo.      
define variable viCounter       as integer   no-undo.      
define variable vcShow          as character no-undo.
define variable vcLine          as character no-undo.
define variable vcInLine        as character no-undo.
define variable viCounterInline as integer   no-undo.      
define variable viGameId        as integer   no-undo.      
    
input from value(search("day02\day02_input.txt")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
    
  if vcLIne = "" then leave.    
    
  viGameId = int(entry(2, trim(entry(1, vcLine, ":":u)), " ")).
    
  do viCounter = 1 to num-entries(entry(2, vcLine, ":":u), ";":u):
    vcShow = trim(entry(viCounter, entry(2, vcLine, ":":u), ";":u)).
      
    do viCounterInline = 1 to num-entries(vcShow, ","):
      vcInline = trim(entry(viCOunterInline, vcShow, ",")).
        
      case trim(entry(2, vcInLine, " ")):
        when "blue" then 
          if int(trim(entry(1, vcInLine, " "))) > viMaxBlue then
            viGameId = 0.
        when "red" then 
          if int(trim(entry(1, vcInLine, " "))) > viMaxRed then
            viGameId = 0.
        when "green" then 
          if int(trim(entry(1, vcInLine, " "))) > viMaxGreen then
            viGameId = 0.
      end case.             
    end.        
  end.
    
  viSum = viSum + viGameid.
    
end.  
input close.

message viSum view-as alert-box info.
