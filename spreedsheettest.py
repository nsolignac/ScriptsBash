import gspread
import pprint
from oauth2client.service_account import ServiceAccountCredentials
from tabulate import tabulate

scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']

credentials = ServiceAccountCredentials.from_json_keyfile_name('testSondeos.json', scope)
gc = gspread.authorize(credentials)
wks = gc.open('TestSondeos').sheet1
pp = pprint.PrettyPrinter(indent=4)

"""
#Print columna 1
projectsT = wks.acell('A1').value
print (projectsT + '\n')
projects = wks.col_values(1)
pp.pprint(projects[1:])
print("")

#Print columna 2
statesT = wks.acell('B1').value
print (statesT + '\n')
states = wks.col_values(2)
pp.pprint(states[1:])
print("")
"""

#Toda la tabla en formato Tabulado
def Results(source):
    data = source.get_all_values()
    print tabulate(data)

Results(wks)
