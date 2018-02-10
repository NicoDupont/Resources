"""
------------------------------------
 Creation date : 02/02/2018  (fr)
 Last update :   10/02/2018
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""

#plot ecdf
def plot_single_ecdf(data,title='',xlabel=''):
    # Empirical cumulative distribution functions (ECDF)
    # Compute ECDF for a one-dimensional array of measurements and plot it.
    data = data.dropna()
    n = len(data)
    x = np.sort(data)
    y = np.arange(1, len(x)+1) / len(x)
    title = title+' Cumulative Distribution'
    plt.plot(x, y, marker='.')
    plt.margins(0)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel('ECDF (% of oberservation)')
    plt.ylim(0,1)
    

#PlotEcdf(df[column],title='ColumnName',xlabel='$')
#plt.show()
