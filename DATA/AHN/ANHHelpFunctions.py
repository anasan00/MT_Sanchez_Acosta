def split_municipios(row):
    municipios = row["MUNICIPIO(S)"].split(" - ")
    if len(municipios) > 1:
        # Create a new row for each municipio
        rows = []
        for municipio in municipios:
            new_row = row.copy()
            new_row["MUNICIPIO(S)"] = municipio
            # Divide production data columns equally
            for col in row.index[2:]:
                new_row[col] /= len(municipios)
            rows.append(new_row)
        return rows
    else:
        return [row]

def update_department(dataframe, municipio_name, current_department, new_department):
    """
    Update the department of a given municipio in the dataframe.
    
    Parameters:
        dataframe (pd.DataFrame): The DataFrame containing the data.
        municipio_name (str): The name of the municipio to update.
        current_department (str): The current department for verification.
        new_department (str): The new department to assign.
        
    Returns:
        pd.DataFrame: Updated DataFrame.
    """
    # Locate the row where MUNICIPIO(S) contains the municipio_name and DEPARTAMENTO(S) matches current_department
    condition = (dataframe["MUNICIPIO(S)"].str.contains(municipio_name, case=False)) & \
                (dataframe["DEPARTAMENTO(S)"] == current_department)
    
    # Update the department to the new value
    dataframe.loc[condition, "DEPARTAMENTO(S)"] = new_department
    
    # Verify the update
    updated_rows = dataframe[condition]
    if updated_rows.empty:
        print(f"No matching entry found for MUNICIPIO(S)='{municipio_name}' in DEPARTAMENTO(S)='{current_department}'.")
    else:
        print(f"Updated the following entries:\n{updated_rows[['DEPARTAMENTO(S)','MUNICIPIO(S)']]}")
    
    return dataframe