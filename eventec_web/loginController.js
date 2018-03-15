/**
 * Created by Andres on 3/15/2018.
 */
angular.module('loginModule',["ngRoute","ngResource"])
    .controller('loginController', function($scope,$http,$location) {
        // modelo de datos.
        $scope.ida = "";
        $scope.pass = "";
        var user={
            id:null
        };
        /**
         * Ejecuta el inicio de sesión.
         */
        $scope.doLogin = function () {
            var ida=Base64.encode($scope.ida);
            var pass=Base64.encode($scope.pass);
            console.log($scope.ida);
            console.log($scope.pass);
            console.log(ida);
            console.log(pass);
            $http({
                method:"GET",
                url: "http://localhost/Administradores/Administrador?ida="+ida+"&pass="+pass
            }).then(function mySucces(response){
                var estado=response.data;
                if(estado.success==true){
                    user.id=$scope.ida;
                    saveSession(user);
                    window.location.href = ('users/index.html');
                }
                else{
                    alert("Credenciales incorrectas");
                    console.log("Credenciales incorrectas");
                }
            });
        }
        /**
         * Guarda la sesión en el almacenamiento local del navegador.
         * @param json JSON de origen.
         */
        function saveSession(json) {
            sessionStorage.setItem("session.user",json.id);
            console.log("Sesión guardada.");
        }
    });