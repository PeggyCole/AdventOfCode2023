
define variable vcLine          as character no-undo.
define variable viRow           as integer   no-undo.
define variable viColumn        as integer   no-undo.
define variable viCurrentNumber as integer   no-undo.
define variable viSum           as integer   no-undo.
define variable vlSymbolFound   as logical   no-undo.

define temp-table ttPosition no-undo
  field IdRow         as integer
  field IdColumn      as integer
  field PositionValue as character 
  field Digit         as integer
  index PK as primary unique IdRow         IdColumn
  index IdRow                IdRow
  index IdColumn             IdCOlumn
  index positionValue        positionValue.
  
define buffer bttPosition for ttPosition.

input from value(search("day03\day03_input.txt")).
  
repeat 
  on error undo, leave 
  on endkey undo, leave:
       
  import unformatted vcLine.
  
  viRow = viRow + 1.
  
  do viColumn = 1 to length(vcLine):
    create ttPosition.
    assign 
      ttPosition.IdRow         = viRow
      ttPosition.IdColumn      = viColumn    
      ttPosition.PositionValue = substring(vcLine, viColumn, 1).
    
    if lookup(ttPosition.PositionValue, "0,1,2,3,4,5,6,7,8,9") > 0 then
      ttPosition.Digit = int(ttPosition.PositionValue). 
    else
      ttPosition.Digit = ?.  
       
  end.
end.  
input close.

for each ttPosition by IdRow by IdColumn:
  if ttPosition.Digit = ? then 
  do:
    if vlSymbolFound then 
      viSum = viSum + viCurrentNumber.
    
    assign
      viCurrentNumber = 0
      vlSymbolFound   = no .         
  end.
  else 
  do:
    viCurrentNumber = (viCurrentNumber * 10) + ttPosition.Digit.
      
    for first bttPosition no-lock 
      where (bttPosition.IdRow = ttPosition.IdRow or bttPosition.IdRow = ttPosition.IdRow - 1 or bttPosition.IdRow = ttPosition.IdRow + 1) 
      and (bttPosition.IdColumn = ttPosition.IdColumn or bttPosition.IdColumn = ttPosition.IdColumn - 1 or bttPosition.IdColumn = ttPosition.IdColumn + 1)
      and bttPosition.Digit eq ?
      and bttPosition.PositionValue ne ".":
      vlSymbolFound = true.
    end.       
  end.
end. 


message viSum view-as alert-box information.

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
540025
---------------------------
OK   Help   
---------------------------

*/

