angular.module('loginModule',["ngRoute","ngResource"])
    .controller('loginController', function($scope,$http) {

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
            user.id=$scope.ida;
            saveSession(user);
            var ida=Base64.encode($scope.ida);
            var pass=Base64.encode($scope.pass);
            console.log(ida);
            console.log(pass);

            $http({
                method:"GET",//
                url: "http://172.24.45.39/Administradores/Administrador?ida="+ida+"&pass="+pass
            }).then(function mySucces(response){
                var estado=response.data;
                if(estado.success==true){
                    console.log(response.data);
                    window.location.href = ('users/MainView.html');
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
            localStorage.setItem("session.user", json.id);
            console.log("Sesión guardada.");
        }
    });