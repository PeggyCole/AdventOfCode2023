define variable vcLine       as character no-undo.
define variable viPosition   as integer   no-undo.
define variable viDummy      as integer   no-undo.
define variable viFirstDigit as integer   no-undo.
define variable viLastDigit  as integer   no-undo. 
define variable viSum        as integer   no-undo.
    
input from value(search("day01\day01_input.txt")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
    
  assign 
    viFirstDigit = ?
    viLastDigit  = ?.
    
  do viPosition = 1 to length(vcLine):
    viDummy = int(substring(vcLine, viPosition, 1)) no-error.
       
    if not error-status:error and viDummy ne ? then 
    do:
      if viFirstDigit = ? then viFirstDigit = viDummy.

      viLastDigit = viDummy.           
    end.
  end.
  
  viSum = viSum + (viFirstDigit * 10) + viLastDigit.
end.  
input close.

message viSum view-as alert-box info.
