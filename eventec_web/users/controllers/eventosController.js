angular.module('userModule')
    .controller('eventosController',function($scope,OperationsEvents){
        console.log("entro");
        $scope.event={
            nombre:"",
            descripcion:"",
            fechaInicio:"",
            fechaFinal:""
        };
        $scope.getlistaEventos =OperationsEvents.getEvento(function(res){
            console.log(res);
            $scope.listaEventos=res;
            console.log($scope.listaEventos);
        });
        $scope.postEventos=function(Evento){
            console.log(Evento);
            OperationsActivities.insertEvento($scope.evento,function(res){
                if(res){
                    OperationsEvents.getEvento(function(res){
                        console.log(res);
                        $scope.listaEventos=res;
                        console.log($scope.listaEventos);
                    });
                    window.location.href = ('eventos');
                }
            });
        }
    });