Data = {};
Data.DataAnjay = [];

jQuery(document).ready(function () {
    Form.Init();
});

var Form = {
    Init: function () {

        $('#bs_datepicker_container input').datepicker({
            autoclose: true,
            container: '#bs_datepicker_container',
            format: "yyyy-mm-dd"
        });

        //--------------------------------- CREATE ---------------------------------

        $("#formAnjay").submit(function (event) {
            if ($("#formAnjay").valid()) {
                Action.Create();
            }
            event.preventDefault();
        });

        $('#formAnjay').validate({
            rules: {
                'date': {
                    customdate: true
                }
            },
            highlight: function (input) {
                $(input).parents('.form-line').addClass('error');
            },
            unhighlight: function (input) {
                $(input).parents('.form-line').removeClass('error');
            },
            errorPlacement: function (error, element) {
                $(element).parents('.form-group').append(error);
            }
        });

        //--------------------------------- CREATE ---------------------------------
    }
}

var Action = {
    Create: function () {
        var params = {
            SerialNo: $("#txtSerial").val(),
            Description: $("#txtDescription").val(),
            Publisher: $("#txtPublisher").val(),
            CreatedDate: $("#txtDate").val()
        }

        $.ajax({
            url: "http://localhost:8095/api/transaction/postBook",
            type: "POST",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(params),
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Common.Alert.Success(data.dataObject);
            }
            else {
                Common.Alert.Warning(data.dataObject);
            }
        })
        .fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 0) {
                Common.Alert.Error("Unknown Error Occured. Failed to connect server")
            } else {
                Common.Alert.Error(jqXHR.responseText)
            }
        })
    }
}