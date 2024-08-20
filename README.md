# Organizacion_del_computador
Implementacion de los 2 TPs hechos en las cursadas 2023C2(individual) y 2024C1(grupal 2) en assembler Intel x86

# TODOs
- TP de Ocas y Zorro tiene un bug, el zorro no valida bien los movimientos en diagonal si terminan en un espacio vacio despues de comer una oca. Esto ocurre por que se valida contra matriz[i] != "o" (no hay una oca), en vez de tambien validar que no sea un "F".
