// NEVER IN PRODUCTION!!!!
// SOURCE:
Model.where( :$where => "sleep(4) || true" ).count
