"""
------------------------------------
 Creation date : 10/02/2018  (fr)
 Last update :   10/02/2018
 Tested on Python 3.6
------------------------------------
"""

#miscellaneous functions to clean data

# remove columns with no standard deviation
def remove_columns_with_no_variation(dataset):
    columns_to_remove = [col for col in dataset.columns if dataset[col].std()==0]
    return dataset.drop(columns_to_remove, axis=1)

# remove duplicated columns on a dataframe
def remove_columns_duplicated(dataset):
    columns_to_remove = []
    n = 0
    while (n < len(dataset.columns)-1):
        col1 = dataset.columns[n]
        m = n+1
        while (m < len(dataset.columns)):
            col2 = dataset.columns[m]
            if dataset[col1].equals(dataset[col2]):
                #print col1, col2
                dataset = dataset.drop(col2, axis=1)
            else:
                m += 1
        n +=1
    return dataset
