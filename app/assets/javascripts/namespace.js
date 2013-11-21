function Namespace(sName) {

 var namespaces = sName.split('.') || [sName];
 var nlen = namespaces.length;
 var root = window;
 var F = function() {};

 for(var i=0; i < nlen; i++) {
  var ns = namespaces[i];
  if(typeof(root[ns])==='undefined') {
   root = root[ns] = F;
   root = root.prototype = F;
  }
  else
   root = root[ns];
 }
}