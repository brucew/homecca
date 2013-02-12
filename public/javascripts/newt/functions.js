/**
 * @author deepak
 */
function add_modal(name,id){
                $('.processing').hide();
                $('#todo_item_name').val(name);
                $('#todo_catalogue_item_id').val(id);
                $("#todo_item").modal({
                    onClose: function(){
                        $.modal.close()
                    }
                });
                $("#add_new_green").addClass("selected");
                return false;
}
function validate_frm(frm){
          $(frm).validate();
          return $(frm).valid();
}
function validate_reg_frm(reg_frm){
  $(reg_frm).validate({
    submitHandler: function(form){submit_after_validation(form)},
    rules: {
      "user[email]": {
        required: true,
        email: true
      },
      "user[first_name]": "required",
      "user[last_name]": "required",
      "user[password]": {
        required: true,
        minlength: 5
      },
      "user[password_confirmation]": {
        required: true,
        minlength: 5,
        equalTo: "#user_password"
      }
    },
    messages:{
      "user[first_name]": "First name is required",
      "user[last_name]": "Last name is required",   
      "user[email]": {
        required: "Please enter email",
        email: "Please enter valid email"
      },
      "user[password]": {
        required: "Enter password",
        minlength: "At least 5 characters"
      },
      "user[password_confirmation]": {
        required: "Please confirm password",
        equalTo: "Password doesn't match"
      }   
    }
  });
  $(reg_frm).valid();
  return false;
}



function filter(val){
    val = val ? "."+val : ''
    $('#ct_blocks_container').quicksand( $('#ct_blocks_container2 li'+val),{easing: 'swing'},function(){
    });
    return false;
}
function bounce_todos() {
    $("#todo_icon").fadeIn(100).animate({top:"-=10px"}, 100).animate({top:"+=10px"}, 100).animate({top:"-=10px"}, 100)
            .animate({top:"+=10px"}, 100).animate({top:"-=10px"}, 100).animate({top:"+=10px"}, 100);
}
function make_added(id,times){
  if (!$("li[data-id='"+id+"']").is("*") ){
    return;
  }
  t_is = times>1 ? "are" :"is";
  t_instance = times>1 ? "instances" :"instance";
  if ($("li[data-id='"+id+"']").children(".checklist_already_added").get(0).tagName==="DIV"){
    $("li[data-id='"+id+"']").children(".checklist_already_added").replaceWith('<a class="checklist_already_added show_bg" href="/todo_items?catalogue_item='+id+'"></a>');
  }
  $("li[data-id='"+id+"']").children(".checklist_already_added")
  .html('<div class="times" rel="tipsy-on-top" title="There '+ t_is +' '+times+' existing '+ t_instance +' in your ToDo list. Feel free to add more if needed.">' +times+ '</div>');
}
function make_added_on_item(id,times){
  t_is = times>1 ? "are" :"is";
  t_instance = times>1 ? "instances" :"instance";
 $('.tbl .tbl_row .item_added')
 .html('<a href="/todo_items?catalogue_item='+id+'"><div class="item_added_content"><div rel="tipsy-on-top" title="There '+ t_is +' '+times+' existing '+ t_instance +' in your ToDo list. Feel free to add more if needed." class="times">'+times+'</div></div></a>');  
}
function show_priority_tip(priority){
  $(".priority_hover").html(priority);
  $(".priority_hover").fadeIn(0);  
}
function hide_priority_tip(){
  $(".priority_hover").fadeOut(0);
}

function submit_after_validation(form){ //function to submit request after jqeury validation, act as submitHandler
    //alert($(form).serializeArray());
    action = $(form).attr("action");//set form action
    jQuery.ajax({
        data: jQuery.param(jQuery(form).serializeArray()), 
        dataType:'script', 
        type:'post', 
        url: action
    });
}
