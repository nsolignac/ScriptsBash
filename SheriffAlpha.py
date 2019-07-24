# DOCS ON PyInquirer!! - https://github.com/CITGuru/PyInquirer

from __future__ import print_function, unicode_literals

from PyInquirer import style_from_dict, Token, prompt, Separator
from pprint import pprint

falsi = False
truti = True

style = style_from_dict({
    Token.Separator: '#cc5454',
    Token.QuestionMark: '#673ab7 bold',
    Token.Selected: '#cc5454',  # default
    Token.Pointer: '#673ab7 bold',
    Token.Instruction: '',  # default
    Token.Answer: '#f44336 bold',
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
