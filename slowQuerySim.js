// NEVER IN PRODUCTION!!!!
// SOURCE: https://stackoverflow.com/questions/12908425/simulate-slow-query-in-mongodb
Model.where( :$where => "sleep(4) || true" ).count
