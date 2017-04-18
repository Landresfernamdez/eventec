/**
 * Created by Erwin on 27/10/2016.
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
    .factory('UserResource',function($resource){
              return $resource("http://localhost:8000/reservations/:id",{id:"@id"},{
                update : {method:'PUT',params:{id:"@id"}}
            });
    })
    /*
    Los factory en angular estan basados en el patron de diseño factoria el cual
    deviuelve instancias de un objeto o variable en este caso es un arreglo de
    objetos json
    */

    .factory('GetFleetResource',function($http){

        var respuesta = function(callback){
            $http.get(
                'http://transportec.azurewebsites.net/fleet/getFleet'
            ).success(function successCallback(response) {
                // Esta funcion es la que se ejecuta
                // cuando la peticion es exitosa
                //response es la variable en la que se devuelven los datos
                //En este caso particular nuestro response esta estructurado de manera que
                //los datos que interesan estan en el atributo content
                //Se devuelve un callback el cual se ejecuta en el controller
                callback(response.content);
            }).error(function errorCallback(response) {
                //En caso de fallo en la peticion entra en esta funcion
                console.log("fallo", response);
                callback(response.content);
            });
        };
        return {respuesta: respuesta};

    })


    .factory('MessageResource', function ($http) {
        /*
        Este factory
        * */
        var authToken = localStorage.getItem('session.token');
        var factory = {

            setMessage: function (message){
                $http({
                    method  : 'POST',
                    url     : 'http://transportec.azurewebsites.net/messages/post?authToken={0}'
                        .format(authToken),
                    data    : message

                })
                    .success(function(data) {
                        if (data.errors) {
                            // Showing errors.
                            console.log("set message error", data.errors)
                        } else {
                            console.log("set message success")
                        }
                    });
            },
            getMessages: function(callback){

                $http.get('http://transportec.azurewebsites.net/messages/getAll?authToken={0}'
                    .format(authToken)
                    )
                    .success(function successCallback(response) {
                        //
                        // when the response is available
                        console.log("entro", response);
                        callback(response.content);
                    }).error(function errorCallback(response) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                    console.log("fallo", response);
                    callback(response.content);
                });
            }
        };
        return factory;
    });
