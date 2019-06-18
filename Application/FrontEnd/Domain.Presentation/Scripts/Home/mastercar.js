Data = {};
Data.DataAnjay = [];

jQuery(document).ready(function () {
    Form.Init();
});

var Form = {
    Init: function () {

        Dropzone.autoDiscover = false;
        $("#frmFileUpload").dropzone({
            url: "/Document/DocumentController.ashx",
            addRemoveLinks: true,
            success: function (file, response) {
                file.previewElement.classList.add("dz-success");
                Common.Function.UploadDocument(JSON.parse(response));
            },
            error: function (file, response) {
                Common.Alert.Error("Ooops Error......")
                file.previewElement.classList.add("dz-error");
            }
        });

        $('#bs_datepicker_container input').datepicker({
            autoclose: true,
            container: '#bs_datepicker_container',
            format: "yyyy-mm-dd"
        });

        //--------------------------------- READ ---------------------------------

        $('#tblMstCar').dataTable({
            "filter": false,
            "destroy": true,
            "data": []
        });

        $(window).resize(function () {
            $("#tblMstCar").DataTable().columns.adjust().draw();
        });


        Action.Read();

        $("#tblMstCar tbody").on("click", "button.btDelete", function (e) {
            var table = $("#tblMstCar").DataTable();
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
                        Action.Delete(Data.Selected.AutoID);
                        e.preventDefault();
                    }
                });
            }
        });

        $("#tblMstCar tbody").on("click", "button.btEdit", function (e) {
            var table = $("#tblMstCar").DataTable();
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

        //--------------------------------- CREATE BULK ---------------------------------

        $("#formAnjayBulk").submit(function (event) {
            if ($("#formAnjayBulk").valid()) {
                Form.AddtoDatatable();
            }
            event.preventDefault();
        });

        $('#formAnjayBulk').validate({
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

        $("#tblMstCarBulk").DataTable({
            "language": {
                "emptyTable": "No data available in table"
            },
            "filter": false,
            "destroy": true,
            "columns": [
                { data: "Name" },
                { data: "CreatedDate" },
                {
                    mRender: function (data, type, full) {
                        var strReturn = "";
                        strReturn += "<button type='button' title='Delete' class='mb-sm btn btn-danger btDeleteBulk'>DELETE</button>";
                        return strReturn;
                    }
                }
            ],
            "columnDefs": [
                { "targets": [0], "width": "40%" },
                { "targets": [1], "width": "40%" },
                { "targets": [2], "width": "20%" }
            ]
        });

        $(window).resize(function () {
            $("#tblMstCarBulk").DataTable().columns.adjust().draw();
        });

        $("#tblMstCarBulk tbody").on("click", "button.btDeleteBulk", function (e) {
            var table = $("#tblMstCarBulk").DataTable();
            table.row($(this).parents("tr")).remove().draw();
        });

        $("#btnSaveBulk").unbind().click(function () {
            var table = $("#tblMstCarBulk").DataTable();
            var data = table.rows().data();

            $.each(data, function (i, item) {
                item.IsActive = 1;
                Data.DataAnjay.push(item);
            });

            Action.CreateBulk(Data.DataAnjay);
        });

        //--------------------------------- CREATE BULK ---------------------------------

        //--------------------------------- UPDATE ---------------------------------

        $("#formUpdate").submit(function (event) {
            if ($("#formUpdate").valid()) {
                Action.Update();
            }
            event.preventDefault();
        });

        //--------------------------------- UPDATE ---------------------------------

        //--------------------------------- DOWNLOAD ---------------------------------
        $("#btnDownloadFile").unbind().click(function () {
            Common.Function.LoadLoadingIcon();
            Action.GetLatestDocID();
            Common.Function.CloseLoadingIcon();
        });
        //--------------------------------- DOWNLOAD ---------------------------------
    },
    FillTextBoxforEdit: function () {
        $("#txtEditAutoID").val(Data.Selected.AutoID);
        $("#txtEditNama").val(Data.Selected.Name);
        $("#txtEditDate").val(Data.Selected.CreatedDate);
    },
    AddtoDatatable: function () {
        var table = $("#tblMstCarBulk").DataTable();
        var data = {
            Name: $("#txtNamaBulk").val(),
            CreatedDate: $("#txtDateBulk").val()
        }

        table.rows.add([data]).draw();
    }
}

var Action = {
    Create: function () {
        var params = {
            Name: $("#txtNama").val(),
            CreatedDate: $("#txtDate").val(),
            IsActive: 1
        }

        $.ajax({
            url: webApi.url + "api/transaction/postCar",
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
    CreateBulk: function (data) {
        $.ajax({
            url: webApi.url + "api/transaction/postCarBulk",
            type: "POST",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify(data),
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Common.Alert.Success(data.dataObject);
                Action.Read();
                $("#tblMstCarBulk").DataTable().clear().draw();
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
        $("#tblMstCar").DataTable({
            "language": {
                "emptyTable": "No data available in table"
            },
            "ajax": {
                "url": webApi.url + "api/transaction/getAll",
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
                { data: "AutoID" },
                { data: "Name" },
                { data: "IsActive" },
                { data: "CreatedDate" }
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
            AutoID: $("#txtEditAutoID").val(),
            Name: $("#txtEditNama").val(),
            CreatedDate: $("#txtEditDate").val(),
            IsActive: 1
        }

        $.ajax({
            url: webApi.url + "api/transaction/putCar",
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
    Delete: function (autoID) {
        $.ajax({
            url: webApi.url + "api/transaction/deleteCar/" + autoID,
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
    },
    GetLatestDocID: function () {
        $.ajax({
            url: webApi.url + "api/document/GetLatestDocID",
            type: "GET",
            dataType: "json",
            contentType: "application/json"
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Data.DocID = data.dataObject;
                Action.GetDocument();
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
    GetDocument: function () {
        var params = {
            id: Data.DocID
        }

        $.ajax({
            url: webApi.url + "api/document/getDocURL",
            type: "GET",
            dataType: "json",
            contentType: "application/json",
            data: params
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Common.Function.DownloadDocument(data.dataObject);
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
