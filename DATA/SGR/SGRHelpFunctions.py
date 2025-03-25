# load modules

import pandas as pd
import unidecode

def add_mun_code(muni,df_g): 
    """
    Join the municipality names to the codes from the National statistics department (DANE).

    Parameters
    ----------
    muni : pandas dataframe.
        Daframe containing the municipalities names and code from DANE.
    df_g : pandas dataframe.
        Dataframe with municipalitiy names and the information to be joined.

    Returns
    -------
    mer : pandas dataframe.
        Dataframe with information and municipality code. 

    """
    #keep necessary variables from municipality data
    muni_merge=muni[['muncode','munname','Nombre']]
    # get rid of accents on both variables 
    muni_merge['munname']=[unidecode.unidecode(string) for string in muni_merge['munname']]
    muni_merge['Nombre']=[unidecode.unidecode(string) for string in muni_merge['Nombre']]
    df_g['municipio']=[unidecode.unidecode(string) for string in df_g['municipio']]
    df_g['departamento']=[unidecode.unidecode(string) for string in df_g['departamento']]
    
    # manual rules 
    df_g.replace('CASTILLA NUEVA','CASTILLA LA NUEVA',inplace=True)
    df_g.replace('CUCUTA','SAN JOSE DE CUCUTA',inplace=True)
    df_g.replace('LA JAGUA IBIRICO','LA JAGUA DE IBIRICO',inplace=True)
    df_g.replace('MOMPOS','SANTA CRUZ DE MOMPOX',inplace=True)
    df_g.replace('VILLA NUEVA','VILLANUEVA',inplace=True)
    df_g.replace('VISTA HERMOSA','VISTAHERMOSA',inplace=True)
    df_g.replace('SAN JOSE DE FRAGUA','SAN JOSE DEL FRAGUA',inplace=True)
    df_g.replace('SINCE','SINCELEJO',inplace=True)
    df_g.replace('SAN CAARLOS GUAROA','SAN CARLOS DE GUAROA',inplace=True)
    df_g.replace('RIO NEGRO','RIONEGRO',inplace=True)
        
    mer=muni_merge.merge(df_g, how='outer', left_on=['munname','Nombre'], right_on=['municipio','departamento'], indicator=True,validate='1:1')
    # print to see if smt has to be fixed 
    print(mer[mer['_merge']=='right_only']['municipio'])
    # keep left join 
    mer=mer[mer['_merge']!='right_only']

    # keep only variables of interest
    mer=mer[['muncode','regalias_cop','prod_gravable_bls_kpc']]

    # turn muncode to int 
    mer['muncode']=[int(code) for code in mer['muncode']]
    return mer

def get_revenues(year, code_dict, client, muni):
    """
    Makes a call to the goverment API to download revenue and production data.

    Parameters
    ----------
    year : int.
        Year for which the data is downloaded.
    code_dict : dict.
        Dictionary containing the codes from the API as values and the years as keys.
    client : sodapy.socrata.Socrata
        For autentification on the API.
    muni : pandas dataframe.
        Daframe containing the municipalities names and code from DANE.

    Returns
    -------
    Returns
    -------
    mer : pandas dataframe.
        Dataframe with oil production and revenue information and municipality code.

    """
    code=code_dict[f'{year}']
    results = client.get_all(code)
    df = pd.DataFrame.from_records(results)
    #in case varnames differ
    df.rename({'regaliascop':'regalias_cop'},axis=1,inplace=True)
    df.rename({'tipohidrocarburo':'tipo_hidrocarburo'},axis=1,inplace=True)
    df.rename({'prodgravableblskpc':'prod_gravable_bls_kpc'},axis=1,inplace=True)
    #filter data so only oil is considered 
    df=df[df['tipo_hidrocarburo']=='O'].reset_index()

    # change types of variables and get the to millios of COP or barrels repectively
    df['regalias_cop']=df['regalias_cop'].astype('float64')
    df['regalias_cop']=df['regalias_cop']/1000000

    df['prod_gravable_bls_kpc']=df['prod_gravable_bls_kpc'].astype('float64')
    df['prod_gravable_bls_kpc']=df['prod_gravable_bls_kpc']/1000000
    # sum all capital revenues in the year (since yearly data not necessary to group by year)
    df_g=df.groupby(['municipio','departamento']).sum(numeric_only=True)[['regalias_cop','prod_gravable_bls_kpc']].reset_index()
    
    # assign municipality code 
    mer=add_mun_code(muni,df_g)
    
    #assign year
    mer['year']=year

    #replace NaN with 0 
    mer['regalias_cop'].fillna(0,inplace=True)

    print('\n')

    return mer 

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