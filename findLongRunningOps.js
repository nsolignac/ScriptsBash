// findLongRunningOp.js

db.currentOp().inprog.forEach(
 function(op) {
   if(op.secs_running > 5) printjson(op);
 }
)
