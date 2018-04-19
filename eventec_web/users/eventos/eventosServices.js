/**
 * Created by Andres on 8/4/2017.
 */
angular.module('userModule')
/*
 Existen varias formas de hacer factory una de ellas es mediante la dependencia
 ngResource esta permite conectar con servicios restfull
 en este caso retorna un objeto UserResource el cual posee los metodos
 UserResource.query() : Extrae todos los usuarios
 UserResource.get(id) : recibe el id de un objeto y retorna un registro con todos sus datos
 UserResource.save(objet) : recibe un objeto y guarda el objeto en el backend
 UserResource.update(objet) : recibe un objeto y actualiza el objeto en el backend
 UserResource.delete(objet) : recibe un objeto con el id de el objeto t lo elimina en el backend


 */
/* .factory('UserResource',function($resource){
 return $resource("http://localhost:8000/reservations/:id",{id:"@id"},{
 update : {method:'PUT',params:{id:"@id"}}
 });
 })*/
/*
 Los factory en angular estan basados en el patron de diseño factoria el cual
 deviuelve instancias de un objeto o variable en este caso es un arreglo de
 objetos json
 */

    .factory('OperationsEventos',function($http){

    var respuesta ={
        getEvento:function(cedula,filtro,callback){
            $http.get(
                "http://localhost/Eventos/EventosTodos?cedula="+cedula+"&filtro="+filtro
            ).success(function successCallback(response){
                // Esta funcion es la que se ejecuta
                // cuando la peticion es exitosa
                //response es la variable en la que se devuelven los datos
                //En este caso particular nuestro response esta estructurado de manera que
                //los datos que interesan estan en el atributo content
                //Se devuelve un callback el cual se ejecuta en el controller
                console.log(response);
                callback(response);
            });},
        deleteEvento:function(evento,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/Eventos',
                data    : evento
            })
                .success(function(data) {
                    if (data.errors) {
                        // Showing errors.
                        console.log("set message error", data.errors);
                        alert("Se ha producido un error en la eliminacion");
                        callback(false);
                    } else {
                        alert("La eliminacion fue exitosa");
                        callback(true);
                    }
                });
        },insertEvents:function(events,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/EventosAdd',
                data    : events

            })
                .success(function(data){
                    if (data.errors) {
                        // Showing errors.
                        console.log("set message error", data.errors)
                        alert("Se ha producido un error en la insercion");
                        callback(false);
                    } else {
                        alert("La insercion fue exitosa");
                        callback(true);

                    }
                });

        },updateEvents:function(events,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/EventosUpdate',
                data    : events

            })
                .success(function(data){
                    if (data.errors){
                        // Showing errors.
                        console.log("set message error", data.errors)
                        alert("Se ha producido un error en la update");
                        callback(false);
                    } else{
                        alert("La update fue exitosa");
                        callback(true);
                    }
                });
        /*Endpoints de actividades*/
        },getActivity: function(id,callback){
            $http.get(
                "http://localhost/Activities/Activity?id="+id
            ).success(function successCallback(response){
                // Esta funcion es la que se ejecuta
                // cuando la peticion es exitosa
                //response es la variable en la que se devuelven los datos
                //En este caso particular nuestro response esta estructurado de manera que
                //los datos que interesan estan en el atributo content
                //Se devuelve un callback el cual se ejecuta en el controller
                console.log(response);
                callback(response);
            });
        },
        insertActivity:function(activity,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/ActivitiesAdd',
                data    : activity

            })
                .success(function(data){
                    if (data.errors) {
                        // Showing errors.
                        console.log("set message error", data.errors)
                        alert("Se ha producido un error en la insercion");
                        callback(false);
                    } else {
                        alert("La insercion fue exitosa");
                        console.log("data");
                        console.log(data.data);
                        callback(true);
                    }
                });

        },
        updateActivity:function(activity,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/ActivitiesUpdate',
                data    : activity

            })
                .success(function(data) {
                    if (data.errors){
                        // Showing errors.
                        console.log("set message error", data.errors)
                        alert("Se ha producido un error en la actualizacion");
                        callback(false);
                    } else {
                        alert("La actualizacion fue exitosa");
                        console.log(data);
                        callback(true);

                    }
                });

        },
        deleteActivities:function(actividad,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/ActivitiesDelete',
                data    : actividad

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

        },
        /*Endpoints de personas*/
        getPersona: function(id,callback){
            $http.get(
                "http://localhost/Personas/ActividadesPersona?id="+id
            ).success(function successCallback(response){
                // Esta funcion es la que se ejecuta
                // cuando la peticion es exitosa
                //response es la variable en la que se devuelven los datos
                //En este caso particular nuestro response esta estructurado de manera que
                //los datos que interesan estan en el atributo content
                //Se devuelve un callback el cual se ejecuta en el controller
                console.log(response);
                callback(response);
            });
        },
        deletePersonas:function(PersonaActividad,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/Personas/EliminarActividadesPersona',
                data    : PersonaActividad

            })
                .success(function(data){
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
        },
        getAdministrador: function(callback){
            $http.get(
                "http://localhost/Administradores"
            ).success(function successCallback(response){
                // Esta funcion es la que se ejecuta
                // cuando la peticion es exitosa
                //response es la variable en la que se devuelven los datos
                //En este caso particular nuestro response esta estructurado de manera que
                //los datos que interesan estan en el atributo content
                //Se devuelve un callback el cual se ejecuta en el controller
                console.log(response);
                callback(response);
            });
        },asignarAdministrador:function(AdministradorEvento,callback){
            $http({
                method  : 'POST',
                url     : 'http://localhost/Administradores',
                data    : AdministradorEvento

            })
                .success(function(data){
                    if (data.errors) {
                        // Showing errors.
                        console.log("set message error", data.errors)
                        alert("Se ha producido un error en la insercion");
                        callback(false);
                    } else {
                        alert("Se le asigno el evento con exito");
                        callback(true);
                    }
                });

        }
    };
    return respuesta;
});