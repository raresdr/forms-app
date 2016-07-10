$(document).ready(function () {
    $(document).on('click', '.btn-add', addOptionCall);
    $(document).on('click', '.btn-remove', removeOptionCall);
    $(document).on('click', '.field-remove.btn-remove', removeFieldCall);
    $(document).on('change', 'input.option', updateOption);
    $(document).on('change', 'input.question', updateQuestion);
});

//-----------------------
//AJAX functions

//function used for updating form title/desc - AJAX request
function updateTitleAJAX(url, data, call_type, data_type) {
	$('#submit-form-button').prop( "disabled", true );
    $.ajax({
		type: call_type,
		url: url,
		data: data,
		dataType: data_type,
		success: function(data)
		{
			$('#submit-form-button').prop( "disabled", false );
            if ( data.error && data.message ) {
                $('.span-alert').text(data.message);
            }
		},
		error: function(e)
		{
			$('#submit-form-button').prop( "disabled", false );
            $('.span-alert').text('error processing AJAX request');
		}
	});
}

//function used for AJAX request - reusable
function callAJAX(url, data, call_type, data_type, success_delegate) {
    console.log('in callAJAX');
    $.ajax({
		type: call_type,
		url: url,
		data: data,
		dataType: data_type,
		success: success_delegate,
		error: function(e)
		{
            console.log('error processing AJAX request for ' + url);
		}
	});
}


//-----------------------
//form title, desc & elements functions

function submitForm() {
    updateTitleAJAX('/edit/update_title', $('#desc_form').serialize(), 'POST', 'json');
    $('.desc-alert').text('');
    return false;
}

function removeFormCall() {
    var query = [
        { name: "id", value: $('#id').val() }
    ];
    callAJAX('/remove', $.param(query), 'POST', 'json', removeFormDeleg);
}

function removeFormDeleg(data) {
    window.location.href = "/view_forms";
}

//AJAX request for creating a form element
//returns the element and adds it to the page
function createFormElement( type ) {
    var query = [
        { name: "form_id", value: $('#id').val() },
        { name: "type", value: type },
    ];
    console.log('in createElement');
    callAJAX('/edit/create_element', $.param(query), 'POST', 'html', createElDeleg);
}

function createElDeleg( data ) {
    var lastRowDiv = $('div.row').last();
    var newElement = $(data);
    $(newElement).insertAfter(lastRowDiv);
}

//---------------------------------
//update elements functions
//AJAX request for updating a field option
function updateOption() {
    var id = this.id;
    var split_id = id.split('_');
    
    var query = [
        { name: "id", value: split_id[1] },
        { name: "value", value: this.value },
    ];
    
    if ( this.value ) {
        callAJAX('/edit/update_option', $.param(query), 'POST', 'json');
    }
}

//AJAX request for updating a field question
function updateQuestion() {
    var id = this.id;
    var currentForm = $(this).parents('form');
    
    var query = [
        { name: "id", value: currentForm.find('#elem_id').val() },
        { name: "value", value: this.value },
    ];
    
    if ( this.value ) {
        callAJAX('/edit/update_question', $.param(query), 'POST', 'json');
    }
}

//-----------------------------
//add/remove options functions
function addOptionCall() {
    var currentForm = $(this).parents('form');
    
    var query = [
        { name: "field_id", value: currentForm.find('#elem_id').val() }
    ];
    
    callAJAX('/edit/add_option', $.param(query), 'POST', 'json', addOpDeleg);
}

function addOpDeleg(data) {
	var currentForm = $('input[name=elem_id][value=' + data.field_id + ']').parents('form');
	var lastOption = currentForm.find('div.option:last');
    var newSet = $(lastOption.clone()).insertAfter(lastOption);
	
	newSet.find('input').val('Option');
    newSet.find('input').attr('id','option_' + data.option_id);
}

function removeOptionCall() {
    var currentForm = $(this).parents('form');
    var currentDiv = $(this).parents('div .form-group');
    var id = currentDiv.find('input').attr('id');
    var split_id = id.split('_');
    
    var query = [
        { name: "field_id", value: currentForm.find('#elem_id').val() },
        { name: "option_id", value: split_id[1] }
    ];
    
    if ( currentForm.find('input.option').length > 1 ) {
        callAJAX('/edit/remove_option', $.param(query), 'POST', 'json', removeOpDeleg);
    }
}

function removeOpDeleg(data) {
	var currentSet = $('input[name=option][id=option_' + data.option_id + ']').parents('div .form-group')
    currentSet.remove();
}

function removeFieldCall() {
    var currentForm = $(this).parents('form');
    
    var query = [
        { name: "field_id", value: currentForm.find('#elem_id').val() }
    ];
    
    callAJAX('/edit/remove_field', $.param(query), 'POST', 'json', removeFieldDeleg);
}

function removeFieldDeleg(data) {
	var currentForm = $('input[name=elem_id][value=' + data.field_id + ']').parents('form');
    currentForm.remove();
}

//function for displaying the current form shareable link in an alert box
function getLink( link ) {
	var content = 'Shareable link for your form: ' + link;
	alert(content);
}