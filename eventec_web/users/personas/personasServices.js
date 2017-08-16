angular.module('userModule')
    .factory('OperationsPersonas',function($http,$location){

        var respuesta={
            getPersona: function(callback){
                var ida=localStorage.getItem("session.user");
                $http.get(
                    "http://localhost/Personas"
                ).success(function successCallback(response){
                    // Esta funcion es la que se ejecuta
                    // cuando la peticion es exitosa
                    //response es la variable en la que se devuelven los datos
                    //En este caso particular nuestro response esta estructurado de manera que
                    //los datos que interesan estan en el atributo content
                    //Se devuelve un callback el cual se ejecuta en el controller
                    console.log(response);
                    callback(response);
                }).error(function errorCallback(response) {
                    //En caso de fallo en la peticion entra en esta funcion
                    console.log("fallo", response);
                    callback(response);
                });
            },
            insertPersona:function(persona,callback){
                $http({
                    method  : 'POST',
                    url     : 'http://localhost/Personas',
                    data    : persona

                })
                    .success(function(data) {
                        if (data.errors){
                            // Showing errors.
                            console.log("set message error", data.errors)
                            alert("Se ha producido un error en la insercion");
                            callback(false);
                        } else {
                            alert("La insercion fue exitosa");
                            callback(true);

                        }
                    });

            },
            updatePersona:function(persona,callback){
                $http({
                    method  : 'POST',
                    url     : 'http://localhost/PersonasUpdate',
                    data    : persona

                })
                    .success(function(data) {
                        if (data.errors){
                            // Showing errors.
                            console.log("set message error", data.errors)
                            alert("Se ha producido un error en la actualizacion");
                            callback(false);
                        } else {
                            alert("La actualizacion fue exitosa");
                            callback(true);

                        }
                    }).error(function(data) {
                    //En caso de fallo en la peticion entra en esta funcion
                    alert("Se ha producido un error en la actualizacion"+data);
                    callback({success: false});
                });

            },
            deletePersonas:function(persona,callback){
                $http({
                    method  : 'POST',
                    url     : 'http://localhost/PersonasDelete',
                    data    : persona

                })
                    .success(function(data) {
                        if (data.errors) {
                            // Showing errors.
                            console.log("set message error", data.errors)
                            alert("Se ha producido un error en la eliminacion");
                            callback(false);
                        } else {
                            alert("La eliminacion fue exitosa");
                            callback(true);
                        }
                    });
            }
        }
        return respuesta;

    });

