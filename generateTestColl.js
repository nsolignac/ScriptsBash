for(var i=0; i < 100; i++){    
  var varName = "component" + i;
  db.collectionName.insert(
   {
     _id: i,
     component: varName,
 specifications: ["spec"+Math.floor(Math.random()*50),"spec"+Math.floor(Math.random()*50),"spec"+Math.floor(Math.random()*50)],
     description:  "test description"+Math.floor(Math.random()*10),
     date: new Date(),
     type: i % 2 ===0  ? "type1" : "type2",
     status: i % 2 ===0
   });
}
