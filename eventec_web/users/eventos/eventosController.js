angular.module('userModule')
    .controller('eventosController',function($scope,OperationsEventos){
        console.log("entro");
        $scope.event={
            idEvento : "",
            nombre:"",
            descripcion:"",
            fechaInicio:"",
            fechaFinal:""
        };

        //Carga los datos al model editar
        $scope.cargarModal = function (evento) {
            $scope.event.idEvento = evento.idEvento;
            $scope.event.nombre = evento.nombre;
            $scope.event.descripcion = evento.descripcion;
            $scope.event.fechaInicio = evento.fechaInicio.substr(0,10);
            $scope.event.fechaFinal = evento.fechaFinal.substr(0,10);


        };
        $scope.crearEvento =function(){
            console.log($scope.event);
            console.log('voy a insertar');
            OperationsEventos.insertEvents($scope.event,function(res){
                if(res){
                    OperationsEventos.getEvento(function(res){
                        console.log(res);
                        $scope.listaEventos=res;
                    });
                }
            });
        };
        $scope.actualizar = function(){
            console.log($scope.event);
            console.log('voy a actualizar');

            OperationsEventos.updateEvents($scope.event,function(res){
                if(res){
                    OperationsEventos.getEvento(function(res){
                        console.log(res);
                        $scope.listaEventos=res;
                    });
                }
            });
        };
        $scope.getlistaEventos = OperationsEventos.getEvento(function(res){
            console.log(res);
            $scope.listaEventos=res;
            console.log($scope.listaEventos);
        });


        $scope.eliminar = function deleteEvento(event){
            console.log("imprime:"+event);
            OperationsEventos.deleteEvento(event,function(response){
                if(response.success){

                }
                OperationsEventos.getEvento(function(res){
                    console.log(res);
                    $scope.listaEventos=res;
                });
            });

        };
    });