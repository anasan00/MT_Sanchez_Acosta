# -*- coding: utf-8 -*-
"""
This script contains useful functions for the preprocessing of the data. 

"""
# load packages
import pandas as pd


def store_data_from_API(client,code_cat, filename): 
    """
    Function to call the API and stroe the results. 
    ! Make sure that the working directory is right

    Parameters
    ----------
    client: sodapy objecr
    code_cat : STR
        Code for the API
    filename : STR
        Name under which the results should be stored 

    Returns
    -------
    Dataframe of the results 

    """
    #get results 
    results = client.get_all(f"{code_cat}")
    # Convert to pandas DataFrame
    results_df = pd.DataFrame.from_records(results)
    #save the data 
    results_df.to_csv(f'{filename}')
    
    return results_df

def map_AB_AP(modality,iniciative,g1,g2,g3,
           clash_cat='COMBATE Y/O CONTACTO ARMADO',
           attacks_cat=['AMETRALLAMIENTO DESDE EL AIRE',
 'ATAQUE A INSTALACIÓN DE LAS FUERZAS ARMADAS ESTATALES',
 'ATAQUE A POBLACIÓN',
 'BOMBARDEO (ATAQUE AÉREO)',
 'EMBOSCADA',
 'HOSTIGAMIENTO','OPERACIÓN MILITAR'],ap_flag=False):
    """
    This function takes an entry of an event and assigns it to one category. 
    T

    Parameters
    ----------
    modality : STR
        The modality of the event.
    iniciative : STR
        The initiative of the event.
    g1 : STR
        Group in the group 1 column.
    g2 : STR
        Group in the group 2 column.
    g3 : STR
        Group in the group 3 column.
    clash_cat : STR, optional
        Modality which cause the event to be classified as a clash. 
        The default is 'COMBATE Y/O CONTACTO ARMADO'.
    attacks_cat : List, optional
        Modality which cause the event to be classified as an attack. 
        The default is 'COMBATE Y/O CONTACTO ARMADO'. The default is ['AMETRALLAMIENTO DESDE EL AIRE', 'ATAQUE A INSTALACIÓN DE LAS FUERZAS ARMADAS ESTATALES', 'ATAQUE A POBLACIÓN', 'BOMBARDEO (ATAQUE AÉREO)', 'EMBOSCADA', 'HOSTIGAMIENTO','OPERACIÓN MILITAR'].
    ap_flag : BOOL, optional
        To state if the Attacks to villages dataset (AP) is beeing mapped. The default is False.

    Returns
    -------
    str
        Category of the event. The possible categories are: clash, govattack, parattack, posdattack and other.

    """
    
    # differentiate between attack and clash based on modality
    if modality == clash_cat:
        return 'clash'
    
    elif modality in attacks_cat or ap_flag:
        
        # Goverment attacks 
        if iniciative=='FUERZAS ARMADAS ESTATALES': 
            return 'govattack'
        
        # Attacks from other groups
        elif iniciative=='GRUPOS ARMADOS ORGANIZADOS' or ap_flag: 
            if g1 == 'AGENTE DEL ESTADO':
                 
                if g2 == 'AGENTE DEL ESTADO':
                    
                    if g3 == 'GUERRILLA':
                        return 'guerrattack'
                    elif g3 == 'GRUPO PARAMILITAR':
                        return 'parattack'
                    elif g3 == 'GRUPO POSDESMOVILIZACIÓN':
                        return 'posdattack'
                    else: 
                        return 'other'
                    
                elif g2 == 'GUERRILLA':
                    return 'guerrattack'
                
                elif g2 == 'GRUPO PARAMILITAR':
                    return 'parattack'
                
                elif g2 == 'GRUPO POSDESMOVILIZACIÓN':
                    return 'posdattack'
                
                else: 
                    return 'other'
                
            if g1 == 'GUERRILLA':
                return 'guerrattack'
            
            elif g1 == 'GRUPO PARAMILITAR':
                return 'parattack'
            
            elif g1 == 'GRUPO POSDESMOVILIZACIÓN':
                return 'posdattack'
            
            else: 
                return 'other'
            
    else: 
        return 'other'

def map_resposable(sufixact,df):
    """
    This function, takes a dataframe containing event where there is a resposible party and assign them a category.

    Parameters
    ----------
    sufixact : STR
        Suffix, that describes the action. The possible entrances are: 'attack','mass' and 'sec'.
            
    df : PANDAS DF
        Dataframe containg the events to be mapped.

    Returns
    -------
    df : PANDAS DF
        Dataframe containg the events to be mapped and dummi columns for each category. 

    """
    df[f'par{sufixact}']=df.presunto_responsable.isin(['GRUPO PARAMILITAR', 'AGENTE DEL ESTADO - GRUPO PARAMILITAR'])
    df[f'guerr{sufixact}']=df.presunto_responsable.isin(['GUERRILLA'])
    df[f'posd{sufixact}']=df.presunto_responsable.isin(['GRUPO POSDESMOVILIZACIÓN'])
    
    return df
    
        
        
        
    