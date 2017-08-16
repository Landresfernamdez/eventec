/**
 * Created by Andres on 8/11/2017.
 */
angular.module('userModule')
    .controller('personasController',function($scope,OperationsPersonas,$location,$route){

        $scope.persona={
            cedula:"",
            nombre:"",
            apellido1:"",
            apellido2:"",
            estado:"",
            edad:"",
            direccion:""
        };
        function validar(e) {
            tecla = (document.all) ? e.keyCode : e.which;
            if (tecla==13) alert ('Has pulsado enter');
        }
        $scope.getlistaPersonas =OperationsPersonas.getPersona(function(res){
            console.log(res);
            $scope.listaPersonas=res;
        });
        $scope.postPersonas=function(persona){
            console.log(persona);
            OperationsPersonas.insertPersona($scope.activity,function(res){
                if(res){
                    $scope.listaPersonas=res;
                    $location.path('personas');
                    $route.reload();
                }
            });
        }
        $scope.putPersonas=function(persona){
            console.log(persona);
            OperationsPersonas.updatePersona($scope.persona,function(res){
                if(res){
                    $scope.listaPersonas=res;
                    $location.path('personas');
                    $route.reload();
                }
            });
        }
        $scope.delete=function deletePersona(persona){
            OperationsPersonas.deletePersonas($scope.persona,function(response){
                if(response){
                    $scope.listaPersonas=response;
                    $location.path('personas');
                    $route.reload();
                }
            });

        };

        $scope.actualizarPersonas=function actualizarPersonas(persona){
            $scope.persona=persona;
            console.log("actualiza:");
            console.log(persona);

        }
    });
