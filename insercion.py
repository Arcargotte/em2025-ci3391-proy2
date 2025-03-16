import re

# Definir el patrón (expresión regular) a eliminar
patron = r'^[0-47]int$'

# Archivos de entrada y salida
archivo_entrada = 'insercion_test.txt'
archivo_salida = 'insercion_test_modificado.txt'

# Leer el archivo, procesar cada línea y escribir el resultado
with open(archivo_entrada, 'r') as entrada, open(archivo_salida, 'w') as salida:
    for linea in entrada:
        # Eliminar el patrón de la línea usando re.sub()
        linea_modificada = re.sub(patron, '', linea)
        # Escribir la línea modificada en el archivo de salida
        salida.write(linea_modificada)