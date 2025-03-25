import pandas as pd 

def create_interaction(df, var1,var2): 
    #ls_names=varname.split('x')
    df[f'{var1}x{var2}']=df[f'{var1}']*df[f'{var2}']

def get_correlation(val_df,col_dv,col_base):

    # only take entries where both values are available 
    sub_df=val_df[[f'{col_dv}',f'{col_base}','_merge']][val_df._merge=='both']
    sub_df.dropna(inplace=True)

    # take correlation 
    corr= sub_df[f'{col_dv}'].corr(sub_df[f'{col_base}'])

    return corr