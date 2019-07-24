# DOCS ON PyInquirer!! - https://github.com/CITGuru/PyInquirer

from __future__ import print_function, unicode_literals

from PyInquirer import style_from_dict, Token, prompt, Separator
from pprint import pprint

# DEFINIMOS ALGUNAS VARIABLES
falsi = False
truti = True
# server =
# port =
# user =
# passwd = 

style = style_from_dict({
    Token.Separator: '#48bd2b',
    Token.QuestionMark: '#48bd2b bold',
    Token.Selected: '#48bd2b',  # default
    Token.Pointer: '#48bd2b bold',
    Token.Instruction: '',  # default
    Token.Answer: '#48bd2b bold',
    Token.Question: '',
})


questions = [
    {
        'type': 'checkbox',
        'message': 'Seleccione Opcion',
        'name': 'opciones',
        'choices': [
            Separator('= Mostrar Slow OPTS ='),
            {
                'name': 'MongoDB ',
                'checked': truti # TODO: OPT ID!!!
            },
            {
                'name': 'MariaDB ',
                'checked':  falsi
            },
            {
                'name': 'InfluxDB ',
                'checked': falsi
            },
            Separator('= Reporte Cluster ='),
            {
                'name': 'MongoDB Cluster ',
                'checked': falsi
            },
            {
                'name': 'MariaDB Galera Cluster - Audios ',
                'checked': falsi
            },
            {
                'name': 'MariaDB Galera Cluster -  Reportes ',
                'checked': truti
            },
            {
                'name': 'InfluxDB ',
                'disabled': 'Not a Cluster'
            },
            Separator('= Reporte Servidores ='), # TODO: CON SYSTEMCTL??
            {
                'name': 'MongoDB Cluster',
                'checked': falsi
            },
            {
                'name': 'MariaDB Galera Cluster - Audios',
                'checked': falsi
            },
            {
                'name': 'MariaDB Galera Cluster - Reportes',
                'checked': truti
            },
            {
                'name': 'InfluxDB Server',
                'checked': falsi
            },
            Separator('= Kill OPTS ='), # TODO: USANDO ID DE LA OPT!
            {
                'name': 'MongoDB',
                'checked': truti
            },
            {
                'name': 'MariaDB',
                'checked': falsi
            },
            {
                'name': 'InfluxDB',
                'checked': falsi
            }
        ],
        'validate': lambda answer: 'Debes seleccionar al menos una opcion.........' \
            if len(answer) == 0 else True
    }
]

answers = prompt(questions, style=style)
pprint(answers)
