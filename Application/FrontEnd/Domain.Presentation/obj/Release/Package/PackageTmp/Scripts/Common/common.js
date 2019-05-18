Vue.use(VeeValidate);

var Common = {
    Alert: {
        Warning: function (sa_message) {
            swal({
                title: "",
                text: sa_message,
                type: "warning",
                allowOutsideClick: true,
                confirmButtonClass: "btn-warning"
            });
        },
        WarningThenRoute: function (sa_message, sa_url) {
            swal({
                title: "",
                text: sa_message,
                type: "warning",
                allowOutsideClick: true,
                confirmButtonClass: "btn-warning"
            }, function (isConfirm) {
                if (isConfirm) {
                    window.location.href = sa_url;
                }
            });
        },
        Error: function (sa_message) {
            swal({
                title: "Error on System",
                text: sa_message,
                type: "error",
                allowOutsideClick: true,
                confirmButtonClass: "btn-error"
            });
        },
        Info: function (sa_message) {
            swal({
                title: "",
                text: sa_message,
                type: "info",
                allowOutsideClick: true,
                confirmButtonClass: "btn-info"
            });
        },
        Success: function (sa_message) {
            swal({
                title: "Success",
                text: sa_message,
                type: "success",
                allowOutsideClick: true,
                confirmButtonClass: "btn-success"
            });
        },
        SuccessThenRoute: function (sa_message, sa_url) {
            swal({
                title: "Success",
                text: sa_message,
                type: "success",
                allowOutsideClick: true,
                confirmButtonClass: "btn-success"
            }, function (isConfirm) {
                if (isConfirm) {
                    window.location.href = sa_url;
                }
            });
        }
    },
    Function: {
        LoadLoadingIcon: function () {
            $('.page-loader-wrapper').fadeIn();
        },
        CloseLoadingIcon: function () {
            $('.page-loader-wrapper').fadeOut();
        },
        UploadDocument: function (doc) {
            var params = {
                DocName: doc.DocName,
                DocURL: doc.DocURL,
                DocContent: doc.DocContent
            }

            $.ajax({
                url: webApi.url + "api/document/postDocument",
                type: "POST",
                dataType: "json",
                contentType: "application/json",
                data: JSON.stringify(params)
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
        },
        DownloadDocument: function (doc) {
            window.location = '/Document/DownloadFile?DocName=' + doc.DocName
                           + '&DocURL=' + doc.DocURL + '&DocContent=' + doc.DocContent;
        }
    }
}