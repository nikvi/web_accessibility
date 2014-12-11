/* table.js */
$(document).ready(function() { 
	$('#sortable').DataTable( {
  		"searching": false,
  		"lengthChange": false,
  		"order": [[ 3, "desc" ]],
  		"columnDefs": [ {
      			"targets": 5,
      			"orderable": false
         } ]
	});
});