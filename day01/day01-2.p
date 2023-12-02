define variable vcLine        as character no-undo.
define variable viFirstDigit  as integer   no-undo.
define variable viLastDigit   as integer   no-undo. 
define variable viSum         as integer   no-undo.
  
input from value(search("day01\day01_input.txt")).

repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
     
  run findfirstDigit (input vcLine, output viFirstDigit).
  run findLastDigit (input vcLine, output viLastDigit).
  
  viSum = viSum + (viFirstDigit * 10) + viLastDigit.
end.  
input close.

message viSum view-as alert-box info.
 

// --------------------- INTERNAL PROCEDURES   
procedure convertText:
  
  define input-output parameter iopcLine as character no-undo.
  define output parameter opiDigit as integer no-undo.
 
  opiDigit = ?.
    
  if iopcLine matches "*one*" then opiDigit = 1.
  if iopcLine matches "*two*" then opiDigit = 2.
  if iopcLine matches "*three*" then opiDigit = 3.
  if iopcLine matches "*four*" then opiDigit = 4.
  if iopcLine matches "*five*" then opiDigit = 5.
  if iopcLine matches "*six*" then opiDigit = 6.
  if iopcLine matches "*seven*" then opiDigit = 7.
  if iopcLine matches "*eight*" then opiDigit = 8.
  if iopcLine matches "*nine*" then opiDigit = 9.
    
  if opiDigit ne ? then iopcLine = "".
      
end procedure.

procedure findfirstDigit:
  define input  parameter ipcLine       as character no-undo.
  define output parameter opiFirstDigit as integer   no-undo.
  
  define variable viPosition    as integer   no-undo.
  define variable viDummy       as integer   no-undo.
  define variable vcDigitInText as character no-undo.
  
  opiFirstDigit = ?.
  
  blockfirstdigit:
  do viPosition = 1 to length(ipcLine):
    viDummy = ?.
       
    viDummy = int(substring(ipcLine, viPosition, 1)) no-error.
       
    if viDummy = ? then 
    do:
      vcDigitInText = vcDigitInText + substring(ipcLine, viPosition, 1).         
      run convertText(input-output vcDigitInText, output viDummy).         
    end.
       
    if viDummy ne ? then 
    do:
      opiFirstDigit = viDummy.
      leave blockfirstdigit.
    end.           
  end.
    
end procedure.


procedure findLastDigit:
  define input  parameter ipcLine      as character no-undo.
  define output parameter opiLastDigit as integer   no-undo.
  
  define variable viPosition    as integer   no-undo.
  define variable viDummy       as integer   no-undo.
  define variable vcDigitInText as character no-undo.
  
  opiLastDigit = ?.
  
  blocklastdigit:
  do viPosition = length(ipcLine) to 1 by -1:
    viDummy = ?.
       
    viDummy = int(substring(ipcLine, viPosition, 1)) no-error.
       
    if viDummy = ? then 
    do:
      vcDigitInText = substring(ipcLine, viPosition, 1) + vcDigitInText.         
      run convertText(input-output vcDigitInText, output viDummy).         
    end.
       
    if viDummy ne ? then 
    do:
      opiLastDigit = viDummy.
      leave blocklastdigit.
    end.           
  end.
  
  
end procedure.