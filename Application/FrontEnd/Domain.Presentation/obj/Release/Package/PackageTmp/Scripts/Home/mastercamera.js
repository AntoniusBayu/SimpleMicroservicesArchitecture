Data = {};
Data.DataAnjay = [];

jQuery(document).ready(function () {
    Form.Init();
});

var Form = {
    Init: function () {
        Action.GetBrand();
        //--------------------------------- READ ---------------------------------

        $('#tblMstCamera').dataTable({
            "filter": false,
            "destroy": true,
            "data": []
        });

        $(window).resize(function () {
            $("#tblMstCamera").DataTable().columns.adjust().draw();
        });

        $("#tblMstCamera tbody").on("click", "button.btDelete", function (e) {
            var table = $("#tblMstCamera").DataTable();
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
                        Action.Delete(Data.Selected.brand);
                        e.preventDefault();
                    }
                });
            }
        });

        $("#tblMstCamera tbody").on("click", "button.btEdit", function (e) {
            var table = $("#tblMstCamera").DataTable();
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
        $("#txtEditID").val(Data.Selected.id);
        $("#slEditBrand").val(Data.Selected.brand).trigger('change');
        $("#txtEditCountry").val(Data.Selected.country);
        $("#txtEditRank").val(Data.Selected.rank);
    }
}

var Action = {
    Create: function () {
        var params = {
            brand: $("#slBrand").val(),
            country: $("#txtCountry").val(),
            rank: $("#txtRank").val()
        }

        $.ajax({
            url: webApi.url + "api/camera/postCamera",
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
        $("#tblMstCamera").DataTable({
            "language": {
                "emptyTable": "No data available in table"
            },
            "ajax": {
                "url": webApi.url + "api/camera/getCamera?strBrand=A",
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
                { data: "id" },
                { data: "brand" },
                { data: "country" },
                { data: "rank" }
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
            id: $("#txtEditID").val(),
            brand: $("#slEditBrand").val(),
            country: $("#txtEditCountry").val(),
            rank: $("#txtEditRank").val()
        }

        $.ajax({
            url: webApi.url + "api/camera/putCamera/",
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
    Delete: function (brand) {
        $.ajax({
            url: webApi.url + "api/camera/deleteCamera/" + brand,
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
    GetBrand: function () {
        $.ajax({
            url: webApi.url + "api/Brand/getBrand",
            type: "GET"
        })
        .done(function (data, textStatus, jqXHR) {
            Action.Read();

            $("#slBrand").html("<option></option>")
            $("#slEditBrand").html("<option></option>")

            if (jqXHR.status == 200) {
                $.each(data.dataObject, function (i, item) {
                    $("#slBrand").append("<option value='" + item.brandID + "'>" + item.brandName + "</option>");
                    $("#slEditBrand").append("<option value='" + item.brandID + "'>" + item.brandName + "</option>");
                })

                $('#slBrand').selectpicker('refresh');
                $('#slEditBrand').selectpicker('refresh');
            }
        })
        .fail(function (jqXHR, textStatus, errorThrown) {
            Common.Alert.Error(errorThrown);
        });
    }
}