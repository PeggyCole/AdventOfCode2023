
define variable vcLine            as character no-undo.
define variable viRow             as integer   no-undo.
define variable viColumn          as integer   no-undo.
define variable viCurrentNumber   as integer   no-undo.
define variable viCurrentAsterisk as integer   no-undo initial 1.
define variable viSum             as integer   no-undo.
define variable viFound           as integer   no-undo.

define temp-table ttPosition no-undo
  field IdRow         as integer
  field IdColumn      as integer
  field PositionValue as character 
  field Digit         as integer
  index PK as primary unique IdRow         IdColumn
  index IdRow                IdRow
  index IdColumn             IdCOlumn
  index positionValue        positionValue.
  
define buffer bttPosition  for ttPosition.
define buffer bbttPosition for ttPosition.

input from value(search("day03\day03_input.txt")).


debugger:initiate().
debugger:set-break().
  
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

define variable viNumbersFound as integer no-undo.
for each ttPosition 
  where ttPosition.PositionValue = "*"
  by IdRow by IdColumn:
    
  assign 
    viFound           = 0  
    viCurrentAsterisk = 1.
    
  run FindLeft (ttPosition.IdRow, ttPosition.IdColumn, input-output viFound, output viCurrentNumber). 
  if viCurrentNumber <> 0 then 
    viCurrentAsterisk = viCurrentAsterisk * viCurrentNumber. 
    
  run FindRight (ttPosition.IdRow, ttPosition.IdColumn, input-output viFound, output viCurrentNumber).
  if viCurrentNumber <> 0 then         
    viCurrentAsterisk = viCurrentAsterisk * viCurrentNumber.
  
  run FindOtherRow (ttPosition.IdRow - 1, ttPosition.IdColumn, input-output viFound, input-output viCurrentAsterisk).
  run FindOtherRow (ttPosition.IdRow + 1, ttPosition.IdColumn, input-output viFound, input-output viCurrentAsterisk).
  
  if viFound <> 2 then viCurrentAsterisk = 0.
  
  viSum = viSum + viCurrentAsterisk.
    
end. 


message viSum view-as alert-box information.

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
84584891
---------------------------
OK   Help   
---------------------------


*/



procedure FindLeft:
  define input        parameter ipiRow           as integer no-undo.
  define input        parameter ipiColumn        as integer no-undo.
  define input-output parameter opiFound         as integer no-undo.
  define output       parameter opiCurrentNumber as integer no-undo.
  
  define buffer bttPosition  for ttPosition.
  define buffer bbttPosition for ttPosition.
  
  define variable vcCurrentNumber as character no-undo.
  
  BlockFindLeft:  
  for first bttPosition no-lock 
    where bttPosition.IdRow = ipiRow  
    and bttPosition.IdColumn = ipiColumn - 1
    and bttPosition.Digit ne ? :
    
    opiFound = opiFound + 1.
     
    for each bbttPosition no-lock 
      where bbttPosition.IdRow = ipiRow  
      and bbttPosition.IdColumn < ipiColumn
      by bbttposition.idcolumn descending:
      if bbttposition.Digit = ? then leave BlockFindLeft.
       
      vcCurrentNumber = string(bbttPosition.Digit) + vcCurrentNumber.      
    end.
  end.
  
  if vcCurrentNumber ne "" then
    opiCurrentNumber = int(vcCurrentNumber).  
end procedure.

procedure FindRight:
  define input        parameter ipiRow           as integer no-undo.
  define input        parameter ipiColumn        as integer no-undo.
  define input-output parameter opiFound         as integer no-undo.
  define output       parameter opiCurrentNumber as integer no-undo.
  
  define buffer bttPosition  for ttPosition.
  define buffer bbttPosition for ttPosition.
  
  opiCurrentNumber = ?.
  
  BlockFindRight:  
  for first bttPosition no-lock 
    where bttPosition.IdRow = ipiRow 
    and bttPosition.IdColumn = ipiColumn + 1
    and bttPosition.Digit ne ?
    :
    
    opiFound = opiFound + 1.
     
    for each bbttPosition no-lock 
      where bbttPosition.IdRow = ipiRow
      and bbttPosition.IdColumn > ipiColumn
      by bbttposition.idcolumn:
      
      if bbttposition.Digit = ? then leave BlockFindRight.
      
      if opiCurrentNumber = ? then 
        opiCurrentNumber = bbttPosition.Digit.
      else 
        opiCurrentNumber = (opiCurrentNumber * 10) + bbttPosition.Digit .
      
      
    end.
  end.
  
  if opiCurrentNumber = ? then opiCurrentNumber = 0.
end procedure.  

procedure FindOtherRow:
  define input        parameter ipiRow             as integer no-undo.
  define input        parameter ipiColumn          as integer no-undo.
  define input-output parameter opiFound           as integer no-undo.
  define input-output parameter opiCurrentAsterisk as integer no-undo.
  
  define variable viCurrentNumber   as integer no-undo.
  define variable viCurrentAsterisk as integer no-undo.
  
  define variable vlPrevWasNumber   as logical no-undo.
  define variable vlAllNumbers as logical no-undo initial true.
  
  
  define buffer bttPosition  for ttPosition.
  define buffer bbttPosition for ttPosition.  
  
  do viColumn = 1 to 3:   
    for first bttPosition no-lock 
      where bttPosition.IdRow = ipiRow  
      and bttPosition.IdColumn = ipiColumn - 2 + viColumn // column - 1, column, column + 1 
      by bttPosition.IdColumn
      :
      if bttPosition.Digit eq ? and vlPrevWasNumber then 
      do:
        run FindLeft (bttPosition.IdRow, bttPosition.IdColumn, input-output opiFound, output viCurrentNumber).
        if viCurrentNumber <> 0 then 
          opiCurrentAsterisk = opiCurrentAsterisk * viCurrentNumber.
        vlPrevWasNumber = false.
      end.     
      if viColumn > 1 and bttPosition.Digit ne ? and not vlPrevWasNumber then 
      do:
        run FindRight (bttPosition.IdRow, bttPosition.IdColumn - 1, input-output opiFound, output viCurrentNumber).
        if viCurrentNumber <> 0 then 
          opiCurrentAsterisk = opiCurrentAsterisk * viCurrentNumber.
      end.
      
      if bttPosition.Digit ne ? then  
        vlPrevWasNumber = true.
      else
        vlAllNumbers = false.  
      
      
    end.
  end.
  
  if vlAllNumbers then do: 
    run FindRight (ipiRow, ipiColumn - 2, input-output opiFound, output viCurrentNumber).
    
    if viCurrentNumber <> 0 then 
      opiCurrentAsterisk = opiCurrentAsterisk * viCurrentNumber.
  end. 
  

end procedure.