Data = {};
Data.Chart = {};
Hari = [];
TotalRequest = [];
TotalError = [];

jQuery(document).ready(function () {
    Form.Init();
});

var Form = {
    Init: function () {
        Action.Read();
    },
    DisplayRequest: function () {
        $('#postRequest').countTo({
            from: 0,
            to: Data.PostRequest,
            speed: 3000,
            refreshInterval: 100,
            formatter: function (value, options) {
                return value.toFixed(options.decimals);
            }
        });

        $('#getRequest').countTo({
            from: 0,
            to: Data.GetRequest,
            speed: 3000,
            refreshInterval: 100,
            formatter: function (value, options) {
                return value.toFixed(options.decimals);
            }
        });

        $('#putRequest').countTo({
            from: 0,
            to: Data.PutRequest,
            speed: 3000,
            refreshInterval: 100,
            formatter: function (value, options) {
                return value.toFixed(options.decimals);
            }
        });

        $('#deleteRequest').countTo({
            from: 0,
            to: Data.DeleteRequest,
            speed: 3000,
            refreshInterval: 100,
            formatter: function (value, options) {
                return value.toFixed(options.decimals);
            }
        });
    },
    DisplayChart: function () {
        var config = null;

        config = {
            type: 'line',
            data: {
                labels: Hari,
                datasets: [{
                    label: "User Activitiy",
                    data: TotalRequest,
                    borderColor: 'rgba(0, 188, 212, 0.75)',
                    backgroundColor: 'rgba(0, 188, 212, 0.3)',
                    pointBorderColor: 'rgba(0, 188, 212, 0)',
                    pointBackgroundColor: 'rgba(0, 188, 212, 0.9)',
                    pointBorderWidth: 1
                }, {
                    label: "Total Error",
                    data: TotalError,
                    borderColor: 'rgba(233, 30, 99, 0.75)',
                    backgroundColor: 'rgba(233, 30, 99, 0.3)',
                    pointBorderColor: 'rgba(233, 30, 99, 0)',
                    pointBackgroundColor: 'rgba(233, 30, 99, 0.9)',
                    pointBorderWidth: 1
                }]
            },
            options: {
                responsive: true,
                legend: {
                    display: true,
                    labels: {
                        fontColor: 'rgb(255, 99, 132)'
                    }
                }
            }
        }

        return config;
    },
    DisplayChartRadar: function () {
        var config = null;

        config = {
            type: 'radar',
            data: {
                labels: Hari,
                datasets: [{
                    label: "User Activitiy",
                    data: TotalRequest,
                    borderColor: 'rgba(0, 188, 212, 0.75)',
                    backgroundColor: 'rgba(0, 188, 212, 0.3)',
                    pointBorderColor: 'rgba(0, 188, 212, 0)',
                    pointBackgroundColor: 'rgba(0, 188, 212, 0.9)',
                    pointBorderWidth: 1
                }, {
                    label: "Total Error",
                    data: TotalError,
                    borderColor: 'rgba(233, 30, 99, 0.75)',
                    backgroundColor: 'rgba(233, 30, 99, 0.3)',
                    pointBorderColor: 'rgba(233, 30, 99, 0)',
                    pointBackgroundColor: 'rgba(233, 30, 99, 0.9)',
                    pointBorderWidth: 1
                }]
            },
            options: {
                responsive: true,
                legend: {
                    display: true,
                    labels: {
                        fontColor: 'rgb(255, 99, 132)'
                    }
                }
            }
        }

        return config;
    }
}

var Action = {
    Read: function () {
        $.ajax({
            url: webApi.url + "api/transaction/getDashboard",
            type: "GET",
            dataType: "json",
            contentType: "application/json"
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Data = data.dataObject;
                Form.DisplayRequest();
                Action.ReadChart();
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
    ReadChart: function () {
        $.ajax({
            url: webApi.url + "api/transaction/getDashboard2",
            type: "GET",
            dataType: "json",
            contentType: "application/json"
        }).done(function (data, textStatus, jqXHR) {
            if (jqXHR.status == 200) {
                Data.Chart = data.dataObject;

                for (var i = 0; i < Data.Chart.length; ++i) {
                    Hari.push(" Tanggal " + Data.Chart[i].Hari);
                    TotalError.push(Data.Chart[i].TotalError);
                    TotalRequest.push(Data.Chart[i].TotalRequest);
                }

                new Chart(document.getElementById("line_chart").getContext("2d"), Form.DisplayChart('line'));
                new Chart(document.getElementById("radar_chart").getContext("2d"), Form.DisplayChartRadar('radar'));
            }
            else {
                Common.Alert.Warning(data.dataObject);
            }
        })
        .fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 0) {
                Common.Alert.Error("Unknown Error Occured. Failed to connect server");
            } else {
                Common.Alert.Error(jqXHR.responseText);
            }
        })
    }
}