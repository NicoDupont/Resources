Creation date : 23/04/2017  (fr)        
Last update : 23/04/2017    (fr)       
Author(s) : Nicolas DUPONT   
Contributor(s) :

---
### How to convert an excel date to a SAS date

[http://www.sascommunity.org/wiki/Tips:Conversion_from_Excel_Date_to_SAS_Date](http://www.sascommunity.org/wiki/Tips:Conversion_from_Excel_Date_to_SAS_Date)


- SAS_date = Excel_date - 21916;
- SAS_time = Excel_time * 86400;
- SAS_date_time = (Excel_date_time - 21916) * 86400;


### Referential :
- Excel red      : 01/01/1900
- Sas Ref        : 01/01/1960
- Unix timestamp : 01/01/1970


#### Unix Timestamp to a SAS date :

- SAS_date = datepart(dhms('01jan1970'd, 0, 0, datetime));
