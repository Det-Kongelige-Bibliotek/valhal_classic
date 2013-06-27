function OnSubmitForm(arg1, arg2){
    var site = "http://localhost:3000/";
    var link = Routes.arg2();

    //alert("arg = " + link);
    if (arg1 == 'Create') {
        window.open(link ,"_self");
    }
    else if(document.pressed == 'Save') {
        document.form1.action ='';
    }
    else if(document.pressed == 'Cancel') {
        document.form1.action ='';
    }
    return true;
}


