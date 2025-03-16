import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

# Cargar el archivo Excel
archivo = "datos_proy2.xlsx"  # Cambia esto por el nombre de tu archivo
df = pd.read_excel(archivo)

print(df.columns)
