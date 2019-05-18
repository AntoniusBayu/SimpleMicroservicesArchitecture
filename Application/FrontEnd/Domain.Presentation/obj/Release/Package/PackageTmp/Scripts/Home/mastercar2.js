Vue.component("vuejs-datepicker", vuejsDatepicker);

var mstCarVue = new Vue({
    el: '#mstCarVue',
    data: {
        form: {},
        dataResponse: []
    },
    methods: {
        Create: function () {
            this.form.IsActive = true;

            axios.post(webApi.url + "api/transaction/postCar", this.form)
            .then(function (response) {
                if (response.status == 200) {
                    Common.Alert.Success(response.data.dataObject);
                }
                else {
                    Common.Alert.Warning(response.data.dataObject);
                }
            })
            .catch(function (error) {
                if (error.request.status == 0) {
                    Common.Alert.Error("Unknown Error Occured. Failed to connect server")
                } else {
                    Common.Alert.Error(error.message)
                }
            });
        },
        validateBeforeSubmit: function (e) {
            this.$validator.validateAll().then(function (result) {
                if (!result) {
                    return;
                }
                mstCarVue.Create();
            });

            e.preventDefault();
        }
    }
});