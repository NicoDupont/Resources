"""
------------------------------------
 Creation date : 23/04/2017  (fr)
 Last update :   23/04/2017  (fr)
 Author(s) : Nicolas DUPONT
 Contributor(s) :
 Tested on Python 3.6
------------------------------------
"""

# Variance :
def calc_variance(series):
    vals = series.values
    mean = sum(vals) / len(vals)
    variance = 0
    for s in vals:
        difference = s - mean
        square_difference = difference ** 2
        variance += square_difference
    return variance / len(vals)


# Standard deviation :
def calc_std(var):
    return var ** (1/2)


# Covariance :
def calc_covariance(series_one, series_two):
    x = series_one.values
    y = series_two.values
    x_mean = calc_mean(series_one)
    y_mean = calc_mean(series_two)
    x_diffs = [i - x_mean for i in x]
    y_diffs = [i - y_mean for i in y]
    codeviates = [x_diffs[i] * y_diffs[i] for i in range(len(x))]
    return sum(codeviates) / len(codeviates)
