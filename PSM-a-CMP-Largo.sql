SELECT medio FROM esme.Tbl_Mensajes
WHERE dateEnviado BETWEEN "2017-11-01" AND "2017-11-31" AND esmeID IN (60, 160)
GROUP BY medio
