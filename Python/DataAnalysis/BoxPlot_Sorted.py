"""
------------------------------------
 Creation date : 04/02/2018  (fr)
 Last update :   04/02/2018
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""

def BoxplotSorted(df, by, column, stat, order=True):
    # create a new DataFrame with one column by col in the groupby
    # return a new dataframe sorted by median
    df2 = pd.DataFrame({col:vals[column] for col, vals in df.dropna().groupby([by])})
    if stat == 'median':
        meds = df2.median().sort_values(ascending=order)
    elif stat == 'mean':
        meds = df2.mean().sort_values()
    elif stat == 'max':
        meds = df2.max().sort_values()
    elif stat == 'min':
        meds = df2.min().sort_values()
    return df2[meds.index]

df = BoxplotSorted(HpTrain[['MoSold',"SalePrice"]], by='MoSold', column="SalePrice", stat='median')
sns.boxplot(data=df, palette="vlag")
#sns.swarmplot(data=df,size=2, color=".25", linewidth=0)
plt.show()
