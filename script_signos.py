import pandas as pd

# ELIMINAR INSTANCIA 119 PORQUE ESTÁ REPETIDA

def xlsx_to_sql(sql_file, table_name):
    
    columnas_deseadas = ["tipo de signo", "Signo", "Descripción etiqueta"]

    df = pd.read_excel("datos_proy2.xlsx", "solicitudes de marcas", usecols=columnas_deseadas)

    cols_list = df.columns.tolist()
    id_sd = 1 #clave postiza a cada signo

    for i in range(len(cols_list)):
        cols_list[i] = cols_list[i].replace(" ","_")
        cols_list[i] = cols_list[i].lower()
        if (cols_list[i] == "tipo_de_signo"):
            cols_list[i] == "tipo"
        elif (cols_list[i] == "signo"):
            cols_list[i] = "nombre"
        elif (cols_list[i] == "descripción_etiqueta"):
            cols_list[i] = "descripción"
    cols_list.append("id_sd")
    
    with open(sql_file, 'w') as f:
        f.write(f"INSERT INTO {table_name} (")
        f.write(", ".join(cols_list))
        f.write(") VALUES \n")
        
        for i, row in enumerate(df.iterrows()):
            f.write("(")
            toJoin = ", ".join([f"'{str(val)}'" for val in row[1].values])
            toJoin = toJoin + f", {id_sd}"
            id_sd = id_sd + 1

            f.write(toJoin)
            if i == len(df) - 1:
                f.write(");\n")
            else:
                f.write("),\n")


if __name__ == "__main__":
    sql_file = "proy2_insert_signo.sql"
    table_name = "signo_distintivo"
    xlsx_to_sql(sql_file, table_name)