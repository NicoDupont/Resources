// calcul date du jour/ compute day on JavaScript (job entry) component in pentaho data integration

var java_jour;
var date_format;
var date_jour;

java_jour = new java.util.Date();
date_format = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
date_jour = date_format.format(java_jour);
Alert(date_jour);

// http://rpbouman.blogspot.com/2007/04/kettle-tip-using-java-locales-for-date.html
