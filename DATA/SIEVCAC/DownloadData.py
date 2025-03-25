# -*- coding: utf-8 -*-
"""
This script makes a call to Colombia's open data API to retrieve the data from the SIEVCAC project.
After being downloaded, the data is stored, so it can be preprocessed.  
"""
# make sure to install these packages before running:
# pip install pandas
#pip install sodapy


# load fuctions and packages
import pandas as pd
from sodapy import Socrata
from SIEVCACFunctions import store_data_from_API



#ECreate authenticated client (needed for non-public datasets):
client = Socrata('www.datos.gov.co',
                  'Z2piIpUJNdqwwbIIfrRjclwrI',
                  username="anasanchezacosta@live.com",
                  password="PJ^j$%^es9")


# Acciones bélicas // Belic Actions
AB_df=store_data_from_API(client, code_cat="39qq-a72j", filename='RAW DATA/AB.csv')


# Ataques a poblados // Attacks to villages
AP_df=store_data_from_API(client,code_cat="3xsy-8xcp", filename='RAW DATA/AP.csv')


# Masacres // Massacres
MA_df=store_data_from_API(client,code_cat="d78j-f66e", filename='RAW DATA/MA.csv')

# Secuestros // Kidnappings
SE_df=store_data_from_API(client,code_cat="cdw6-jexv", filename='RAW DATA/SE.csv')

# Atentados terroristas // Terroris Attacks
AT_df=store_data_from_API(client,code_cat="yfd7-8c9d", filename='RAW DATA/AT.csv')




