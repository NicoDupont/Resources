//compute previous monday on JavaScript (job entry) component in pentaho data integration

Code:
// get current date and time
// var now = new Date();
date = new java.util.Date();
date.setDate(date.getDate()-0); // -1 pour calculer la veille
dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");

function getPreviousMonday()
{
    var today=new Date();
	return new Date().setDate(today.getDate()-today.getDay()-6);
}

previous_monday = dateFormat.format(getPreviousMonday());

// adjust flow control
true;