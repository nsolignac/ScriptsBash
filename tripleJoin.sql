/*
Problem: List all orders with
product names, quantities, and prices.

This query performs two JOIN operations with 3 tables.
The O, I, and P are table aliases. Date is a column alias.
*/

SELECT U.nombre, N.numero
  FROM CMP_Usuario U
  JOIN CMP_NumeroUsuario NU ON U.id = NU.id_usuario
  JOIN CMP_Numeros N ON N.id = NU.id_numero
ORDER BY U.id
