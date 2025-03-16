import pandas as pd

def xlsx_to_sql(sql_file, table_name):
    
    df = pd.read_excel("datos_proy2.xlsx", "agentes")
    
    cols_list = df.columns.tolist()

    for i in range(len(cols_list)):
        cols_list[i] = cols_list[i].replace(" ","_")
        cols_list[i] = cols_list[i].lower()
        if (cols_list[i] == "número_de_cédula"):
            cols_list[i] = "documento_de_identificación"

    with open(sql_file, 'w') as f:
        f.write(f"INSERT INTO {table_name} (")
        f.write(", ".join(cols_list))
        f.write(") VALUES \n")
        
        for i, row in enumerate(df.iterrows()):
            f.write("(")
            f.write(", ".join([f"'{str(val)}'" for val in row[1].values]))
            if i == len(df) - 1:
                f.write(");\n")
            else:
                f.write("),\n")


if __name__ == "__main__":
    sql_file = "proy2_inserts.sql"
    table_name = "apoderado"
    xlsx_to_sql(sql_file, table_name)