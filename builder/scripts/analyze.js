/**
 * validation code for analyzer form
 */


(function($){

	$(document).ready(function(){
		
		$('#useLastTableNames').click( function(e) {
			e.preventDefault();
			try {
				// Retrieve the object from storage
				var applicationName = $( '#appname' ).val();
				var retrievedObject = JSON.parse(localStorage.getItem( applicationName ) );
				var len = retrievedObject.length;
				var i;
				var id;
				for( i = 0; i < len;  i++ ) {
					id = '#'+retrievedObject[ i ].singular.id;
					$(id).val(retrievedObject[ i ].singular.val );

					id = '#'+retrievedObject[ i ].plural.id;
					$(id).val(retrievedObject[ i ].plural.val );
				}
			} catch ( e ) {
				console.log( 'Browser does not support localStorage' );
			}
		});
		
		/**
		 * attach validation code to the generation form
		 */
		$('#generateForm').submit(function(e){
			
			$('#errorContainer').hide('fast');
			
			var error = '';
			var delim = '';
			var myTables = [];
			var tableNames;
			
			if ($('#appname').val() == '') {
				error += delim + 'Application Name is required';
				delim = '<br/>';
			}
			
			$('.objname-singular').each(function(i) {
				
				var singularId = $(this).attr('id');
				var tableName = singularId.replace('_singular','');
				var pluralId = tableName + '_plural';
				var singularVal = $(this).val();
				var pluralVal = $('#'+pluralId).val();
				
				if (singularVal == '' || pluralVal == '') {
					error += delim + 'Singular and Plural Name are required for table \'' + tableName + '\'';
					delim = '<br/>';
				} else if (singularVal == pluralVal) {
					error += delim + 'Singular and Plural Name cannot be the same for table \'' + tableName + '\'';
					delim = '<br/>';
				}
				tableNames = { singular :{ id:singularId,val:singularVal }, plural :{ id:pluralId,val:pluralVal } };
				myTables.push( tableNames );
				
			});
			
			if (error != '') {
				$('#errorContainer').html('<div class="alert alert-error">'
					+ '<button type="button" class="close" data-dismiss="alert">&times;</button>'
					+ error + '</div>');
				
				$('#errorContainer').show('fast');
				e.preventDefault();
			} else {
				// Put the object into storage
				try {
					var applicationName = $( '#appname' ).val();
					localStorage.setItem(applicationName, JSON.stringify( myTables ) );
				} catch ( e ) {
					console.log( 'Browser does not support localStorage' );
				}
			}
			//e.preventDefault();
		});
		
	});
	
})(jQuery);


