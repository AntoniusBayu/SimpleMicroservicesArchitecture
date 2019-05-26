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

        //--------------------------------- READ ---------------------------------

        $('#tblMstBook').dataTable({
            "filter": false,
            "destroy": true,
            "data": []
        });

        $(window).resize(function () {
            $("#tblMstBook").DataTable().columns.adjust().draw();
        });

        Action.Read();

        $("#tblMstBook tbody").on("click", "button.btDelete", function (e) {
            var table = $("#tblMstBook").DataTable();
            var data = table.row($(this).parents("tr")).data();
            if (data != null) {
                Data.Selected = data;

                swal({
                    title: "Yakin lu mau delete? Yakin bener gak?",
                    text: "",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Yes",
                    cancelButtonText: "No",
                    closeOnConfirm: false,
                    closeOnCancel: true
                }, function (isConfirm) {
                    if (isConfirm) {
                        Action.Delete(Data.Selected.serialNo);
                        e.preventDefault();
                    }
                });
            }
        });

        $("#tblMstBook tbody").on("click", "button.btEdit", function (e) {
            var table = $("#tblMstBook").DataTable();
            var data = table.row($(this).parents("tr")).data();
            if (data != null) {
                Data.Selected = data;
                Form.FillTextBoxforEdit();
            }
        });

        //--------------------------------- READ ---------------------------------

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

        //--------------------------------- UPDATE ---------------------------------

        $("#formUpdate").submit(function (event) {
            if ($("#formUpdate").valid()) {
                Action.Update();
            }
            event.preventDefault();
        });

        //--------------------------------- UPDATE ---------------------------------
    },
    FillTextBoxforEdit: function () {
        $("#txtEditSerialNo").val(Data.Selected.serialNo);
        $("#txtEditDescription").val(Data.Selected.description);
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
            url: "http://localhost:3731/api/book/postBook",
            type: "POST",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(params),
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Common.Alert.Success(data.dataObject);
                Action.Read();
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
    },
    Read: function () {
        $("#tblMstBook").DataTable({
            "language": {
                "emptyTable": "No data available in table"
            },
            "ajax": {
                "url": "http://localhost:3731/api/book/getBook?description=a",
                "dataSrc": "dataObject"
            },
            "filter": false,
            "destroy": true,
            "columns": [
                {
                    mRender: function (data, type, full) {
                        var strReturn = "";
                        strReturn += "<button type='button' title='Edit' class='mb-sm btn btn-primary btEdit'>EDIT</button>";
                        strReturn += "&nbsp;<button type='button' title='Delete' class='mb-sm btn btn-danger btDelete'>DELETE</button>";
                        return strReturn;
                    }
                },
                { data: "serialNo" },
                { data: "description" },
                { data: "publisher" },
                { data: "createdDate" }
            ],
            "columnDefs": [
                { "targets": [0], "width": "20%" },
                { "targets": [1], "width": "10%" },
                { "targets": [2], "width": "25%" },
                { "targets": [3], "width": "15%" },
                { "targets": [4], "width": "30%" }
            ]
        });
    },
    Update: function () {
        var params = {
            SerialNo: $("#txtEditSerialNo").val(),
            Description: $("#txtEditDescription").val()
        }

        $.ajax({
            url: "http://localhost:3731/api/book/putBook/",
            type: "PUT",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(params),
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Common.Alert.Success(data.dataObject);
                Action.Read();
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
    },
    Delete: function (serialNo) {
        $.ajax({
            url: "http://localhost:3731/api/book/deleteBook/" + serialNo,
            type: "DELETE",
            dataType: "json",
            contentType: "application/json"
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Common.Alert.Success(data.dataObject);
                Action.Read();
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