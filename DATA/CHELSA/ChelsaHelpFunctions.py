# load modules 
import pandas as pd
import geopandas as gpd

def read_data(year,num_month,path,prefix):
    """
    This function reads the monthly preprocessed rasterdata, which has been aggregated by municipality. 

    Parameters
    ----------
    year : int.
        The year of the data.
    num_month : int.
        Number corresponding to each moth of the year. E.g January is 1, February is 2 etc.
    path : str.
        Relative path to the folder where the data is located. This folder should cointan new foldeers for every year.
    prefix : str.
        Prefix associated with the unit of the data. prc for precipotations and temp for temperature.

    Returns
    -------
    dta : pandas dataframe
        Table with formated data.

    """
    dta=gpd.read_file(f'{path}/{year}/{year}_0{num_month}.shp')
    dta=dta.rename({'_mean':f'_{prefix}mean'},axis=1)
    dta=dta[['MPIO_CCDGO','MPIO_CNMBR',f'_{prefix}mean','DEPTO','geometry']].dropna(subset=['MPIO_CNMBR',f'_{prefix}mean'])
    dta['month']=num_month
    
    # check for duplicates
    if len(dta[dta.duplicated(subset=['MPIO_CCDGO','MPIO_CNMBR','DEPTO','geometry'],keep=False)])!= 0: 
        print("Some duplicates in:", year, ",",num_month)
    
    return dta

def get_yearly_climate(year,path,prefix):
    """
    This function reads and aggregates the data by taking the mean of each year in every municipality.

    Parameters
    ----------
    year : int.
        The year of the data.
    path : str.
        Relative path to the folder where the data is located. This folder should cointan new foldeers for every year.
    prefix : str.
        Prefix associated with the unit of the data. prc for precipotations and temp for temperature.

    Returns
    -------
    yearly : pandas dataframe
        Table with formated data aggrgated by year.
    """
    year_prc=[]
    for month in range(1,13): 
        print(month)
        data=read_data(year,month,path,prefix)
        year_prc.append(data)
        year_dta=pd.concat(year_prc, ignore_index=True, axis=0)
        yearly=year_dta[['MPIO_CNMBR','geometry','DEPTO',f'_{prefix}mean']].groupby(by=['MPIO_CNMBR','geometry','DEPTO']).mean().reset_index()
        yearly['year']=year
    
    return yearly

def remove_accent(word):
    """
    Removes the accent of all vocals.

    Parameters
    ----------
    word : str.
        Inputed word with accents.

    Returns
    -------
    word : str.
        Word withput accents.

    """
    word=word.replace('Á','A') 
    word=word.replace('É','E')
    word=word.replace('Í','I')
    word=word.replace('Ó','O')
    word=word.replace('Ú','U')
    word=word.replace('Ü','U')
    
    return word

def new_name_from_dept(df,new_name,old_name,cond_dept):
    """
    Takes the name of a municipality and the department that it is located in and changes it to a new name. 
    This is useful for municipalities that are coded with the same name but are located in different departments. 

    Parameters
    ----------
    df : pandas dataframe.
        Dataframe, from which the information is to be taken.
    new_name : str.
        Name to be given to the municipality in question.
    old_name : str.
        Name of the municipality.
    cond_dept : str.
        Name of the department.

    Returns
    -------
    None.

    """
    df['MPIO_CNMBR'] = df.apply(
    lambda row: f"{new_name}" if row['MPIO_CNMBR'] == f'{old_name}' and row['DEPTO'] == f'{cond_dept}' else row['MPIO_CNMBR'],
    axis=1
)


