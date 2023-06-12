math.randomseed(os.time())
basicArrayOfElements={"A","B","C","D","E","F"}
fieldArray = {}
length = 10
height = 10
containMatch3 = false
havePossibleMove = false
minForMatch = 3

function trySwap(x1, y1, x2, y2)
    local temp = fieldArray[y1][x1]
    fieldArray[y1][x1] = fieldArray[y2][x2]
    fieldArray[y2][x2] = temp
    checkMatch3()
    if(containMatch3) then
        return
    else
       fieldArray[y2][x2] = fieldArray[y1][x1]
       fieldArray[y1][x1] = temp
       print()
       print("you can't make this move!")
       print()
    end 
 end
function deleteMatch3Elements()
  match3CoordinateArray = {}
  matchInd = 1
  for y = 1, height do
    matches = 1
    matchSymbol = fieldArray[y][1]
    for x = 2, length + 1 do
      if (fieldArray[y][x] == matchSymbol) then
        matches = matches + 1
      else 
        if (matches >= minForMatch) then
          for removeX = x - matches, x - 1 do
            match3CoordinateArray[matchInd] = y
            match3CoordinateArray[matchInd + 1] = removeX
            matchInd = matchInd + 2
          end
        end
        matchSymbol = fieldArray[y][x]
        matches = 1
      end
    end
  end
  for x = 1, length do
    matches = 1
    matchSymbol = fieldArray[1][x]
    minForMatch = 3
    for y = 2, height do
      if (y == height and fieldArray[y][x] == matchSymbol) then
        if (matches >= minForMatch - 1) then
          for removeY = y - matches, y do
            fieldArray[removeY][x] = 0
          end
        end
      end
      if (fieldArray[y][x] == matchSymbol) then
        matches = matches + 1
      else 
        if (matches >= minForMatch) then
          for removeY = y - matches, y - 1 do
            match3CoordinateArray[matchInd] = removeY
            match3CoordinateArray[matchInd + 1] = x
            matchInd = matchInd + 2
          end
        end
        matchSymbol = fieldArray[y][x]
        matches = 1
      end
    end
  end
  for ind = 1, #match3CoordinateArray - 1, 2 do
    fieldArray[match3CoordinateArray[ind]][match3CoordinateArray[ind + 1]] = 0
  end
  dump()
  fallElements()
 end
function fillTheVoids()
  for y = 1, height do
    for x = 1, length do
      if(fieldArray[y][x] == 0) then
        fieldArray[y][x] = basicArrayOfElements[math.random(1, 6)]
      end
    end
  end
 end
function fallElements()
  for y = 1, height do
    for x = 1, length do
      if(fieldArray[y][x] == 0)then
        for _y = y, 1, -1 do
          if(_y-1 >= 1)then
            local temp = fieldArray[_y][x]
            fieldArray[_y][x] = fieldArray[_y - 1][x]
            fieldArray[_y - 1][x] = temp
          end
        end
      end
    end
  end
  dump()
  fillTheVoids()
 end
function mix()
  print(" \nthe field was shuffled\n ")
  for y = 1, length do
    for x = 1, height do
      local indx = math.random(1, length)
      local indy = math.random(1, height)
      local temp = fieldArray[indy][indx]
          fieldArray[indy][indx] = fieldArray[y][x]
          fieldArray[y][x] = temp
      end
    end
  end
function checkMatch3()
    containMatch3 = false
    for y = 1, height do
       for x = 1, length - 2 do
        if fieldArray[y][x] == fieldArray[y][x + 1] and fieldArray[y][x] == fieldArray[y][x + 2] then
            containMatch3 = true
            return
        end
       end
    end
    for x = 1, length do
       for y = 1, height - 2 do
           if fieldArray[y][x] == fieldArray[y + 1][x] and fieldArray[y][x] == fieldArray[y + 2][x] then
            containMatch3 = true
            return
           end
       end
    end
 end
function checkPossibleMoves()
  havePossibleMove = false
  for y = 1, height do
    for x = 1, length - 1 do
      if (fieldArray[y][x] == fieldArray[y][x + 1]) then
        local pointsArrayHorizontal = {y - 1, x - 1, y, x - 2, y + 1, x - 1, y - 1, x + 2, y, x + 3, y + 1, x + 2, 0}
        for z = 1, #pointsArrayHorizontal - 2, 2 do
          if(pointsArrayHorizontal[z] >= 1 and pointsArrayHorizontal[z] <= height and pointsArrayHorizontal[z + 1] >= 1 and pointsArrayHorizontal[z + 1] <= length) then
            if(fieldArray[y][x] == fieldArray[pointsArrayHorizontal[z]][pointsArrayHorizontal[z + 1]]) then
              havePossibleMove = true
              return
            end
          end
        end
      end
    end
 end
    for x = 1, length do
      for y = 1, height - 1 do
        if((fieldArray[y][x] == fieldArray[y + 1][x])) then
          local pointsArrayVertical = {y - 2, x, y - 1, x - 1, y - 1, x + 1, y + 3, x, y + 2, x - 1, y + 2, x + 1, 0}
          for z = 1, #pointsArrayVertical - 2, 2 do
            if(pointsArrayVertical[z] >= 1 and pointsArrayVertical[z] <= height and pointsArrayVertical[z + 1] >= 1 and pointsArrayVertical[z + 1] <= length) then
              if(fieldArray[y][x] == fieldArray[pointsArrayVertical[z]][pointsArrayVertical[z + 1]]) then
              havePossibleMove = true 
              return
              end
              end
            end
          end
        end
      end
  end
function inputController(_command)
    if _command=="q"then
        os.exit()
    end
    if _command=="r"then
        main()
    end
    commArr = mysplit(_command, " ")
    if commArr[1] == "m" then
        move(commArr[2] + 0, commArr[3] + 0, commArr[4])
    end
 end
function tick()
 local command
    while true do
        command = io.read()
        inputController(command)
        dump()
        checkMatch3()
        while containMatch3 do
            deleteMatch3Elements()
            dump()
            checkMatch3()
        end
        checkPossibleMoves()
        while not havePossibleMove do
            mix()
            dump()
            checkMatch3()
            while containMatch3 do
             deleteMatch3Elements()
             dump()
             checkMatch3()
            end
            checkPossibleMoves()
        end
    end
 end
function dump()
    io.write("  ")
    for x =1, length do
        io.write(x)
        io.write(" ")
    end
    print(" \n   -------------------")
    for y = 1, height do
        if y < 10 then
         io.write(y)
         io.write(" ")
         io.write("|")
        else
         io.write(y)
         io.write("|")
        end
       for x = 1, length do
           
           io.write(fieldArray[y][x])
           io.write(" ")
       end
       print()
   end
    end
function move(_x, _y, direction)
  if (direction == "l") then
    trySwap(_x, _y, _x - 1, _y)
   end
   if(direction == "r") then
    trySwap(_x, _y, _x + 1, _y)
   end
   if(direction == "u") then
    trySwap(_x, _y, _x, _y - 1)
   end
   if(direction == "d") then
    trySwap(_x, _y, _x, _y + 1)
   end
    return
 end
function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
 end
function main()
    print("enter characters separated by a space\n1 - the first letter of the command (m - move)\n2 - the x coordinate\n3 - y coordinate\n4 - exchange direction (l - left, r - right, d - down, u - up)\ncommand example: m 2 7 l\nexit the game: q")
  init()
  checkMatch3()
  checkPossibleMoves()
  while(containMatch3 or not havePossibleMove) do
    init()
    checkMatch3()
    checkPossibleMoves()
  end
  dump()
  tick()
 end
function init()
    containMatch3 = false

    for y = 1, height do
        fieldArray[y] = {}
       for x = 1, length do
           fieldArray[y][x] = basicArrayOfElements[math.random(1, 6)]
       end
    end
 end

main()

