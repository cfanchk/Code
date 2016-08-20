# -*- coding: utf-8 -*-
"""
Created on Wed Jul 27 21:22:47 2016

@author: Thinkpad
"""

import numpy as np
import pandas as pd
from pandas import Series, DataFrame

import datetime
import json

fridge = pd.read_csv('fridge.csv', header=None, names=['item','amount','unit','use-by'])
fridge = fridge.dropna()

def date2num(days):
    num = days[0] + days[1]*100 + days[2]*10000
    return num
    

def isEdible(data):
    dateinfo = [lines.split('/') for lines in data['use-by']]
    todayinfo = datetime.date.today()
    today = [todayinfo.day, todayinfo.month, todayinfo.year]
    todaynum = date2num(today)
    edible = []
    for days in dateinfo:
        days = [int(items) for items in days]
        if(date2num(days)>=todaynum):
            edible.append(True)
        else:
            edible.append(False)
    return edible
    
fridge = fridge[isEdible(fridge)]

recipes = json.load(open('recipes.json'))
supper = []

for cook in recipes:
    could = True
    for ingredients in cook['ingredients']:
        if(could and (int)(ingredients['amount'])>fridge[fridge['item']==ingredients['item']].amount.values):
            could = False
    
    if(could):
        for ingredients in cook['ingredients']:
            fridge[fridge['item']==ingredients['item']].amount -= (int)(ingredients['amount'])
        supper.append(cook['name'])