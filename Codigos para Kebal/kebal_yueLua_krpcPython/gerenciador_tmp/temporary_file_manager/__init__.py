def Read ():
    try:
        file = open("temp_file.txt", "r")
    except:
        return -1
    
    string = file.read()
    return string

def Write (str):
    try:
        file = open("temp_file.txt", "w+")
    except:
        return -1 
    
    file.write(str)

def RecordData ():
    pass

def ReadData ():
    _string = Read()
    data = _string.split(",")
    newdata = []
    for v in data:
        v = v.replace(" ", '')
        if v.isdigit():
            v = int(v)

        newdata.append(v)
    return newdata
