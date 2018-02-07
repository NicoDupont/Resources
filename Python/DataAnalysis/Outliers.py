"""
------------------------------------
 Creation date : 07/02/2018  (fr)
 Last update :   07/02/2018
 Author(s) : Nicolas DUPONT
 Tested on Python 3.6
------------------------------------
"""

# remove outliers with the Quantile based method on normal distribution
def remove_outlier_quantile(df_in, col_name, q1=0.01, q2=0.99):
    quartile_inf = df_in[col_name].quantile(q1)
    quartile_sup = df_in[col_name].quantile(q2)
    #remove value < q1 and > q2 and return a dataframe
    df_out = df_in.loc[(df_in[col_name] > quartile_inf ) & (df_in[col_name] < quartile_sup)]
    return df_out

# remove outliers with the IQR based method on normal distribution
def remove_outlier_iqr(df_in, col_name):
    q1 = df_in[col_name].quantile(0.25)
    q3 = df_in[col_name].quantile(0.75)
    iqr = q3 - q1
    #remove value where : (col_value-col_name.mean()).abs() > 3*col_name.std()  and return a dataframe
    df_out = df_in.loc[(df_in[col_name] > (q1 + (iqr * -1.5))) & (df_in[col_name] < (q3 + (iqr * 1.5)))]
    return df_out

# remove outliers with the Standard Deviation based method on normal distribution
def remove_outlier_std(df_in, col_name, n_std=3):
    col_std = df_in[col_name].std()
    col_mean = df_in[col_name].mean()
    #keep value where : col_value is between col_mean - 3*std and col_mean + 3*std and return a dataframe
    df_out = df_in.loc[(df_in[col_name] > (col_mean - (n_std*col_std))) & (df_in[col_name] < (col_mean + (n_std*col_std)))]
    return df_out
