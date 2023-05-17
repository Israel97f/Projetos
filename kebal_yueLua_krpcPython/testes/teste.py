import sys

sys.path.append("")

from gerenciador_tmp.temporary_file_manager import ReadData

def Mult (arc1, arc2):
    return arc1 * arc2

arc = ReadData()

print(Mult(arc[0], arc[1]))
