angular.module('userModule')
    .controller('eventosController',function($scope,OperationsEventos,$location,$route){
        $scope.idE="";
        $scope.event={
            idEvento : "",
            nombre:"",
            descripcion:"",
            fechaInicio:"",
            fechaFinal:""
        };
        $scope.act_event={
            idActividad:"",
            idEvento:""
        }
        $scope.activity={
            idActividad:"",
            nombre:"",
            descripcion:"",
            fecha:"",
            cupo:"",
            lugar:"",
            horaInicio:"",
            horaFinal:"",
            duracion:"",
            idEvento:""
        };
        $scope.activityofevent={
            nombre:"",
            descripcion:"",
            fecha:"",
            cupo:"",
            lugar:"",
            horaInicio:"",
            horaFinal:"",
            duracion:"",
            idEvento:""
        };
        //Carga los datos al model editar
        $scope.cargarModal = function (evento) {
            $scope.event.idEvento = evento.idEvento;
            $scope.event.nombre = evento.nombre;
            $scope.event.descripcion = evento.descripcion;
            $scope.event.fechaInicio = evento.fechaInicio.substr(0,10);
            $scope.event.fechaFinal = evento.fechaFinal.substr(0,10);
        };
        $scope.gestionarEvento=function(evento){
            $scope.event=evento;
            localStorage.setItem("event.id", JSON.stringify(evento.idEvento));
            window.location.href = ('eventos/eventos.html');
        };
        $scope.crearEvento =function(){
            OperationsEventos.insertEvents($scope.event,function(res){
                if(res){
                    OperationsEventos.getEvento(function(res){
                        console.log("res");
                        console.log(res);
                        $scope.listaEventos=res;

                    });
                }
            });
        };
        $scope.actualizar = function(){
            OperationsEventos.updateEvents($scope.event,function(res){
                if(res){
                    OperationsEventos.getEvento(function(res){
                        $scope.listaEventos=res;
                    });
                }
            });
        };
        $scope.getlistaEventos = OperationsEventos.getEvento(function(res){
            $scope.listaEventos=res;
        });
        $scope.eliminar = function deleteEvento(event){
            OperationsEventos.deleteEvento(event,function(response){
                if(response.success){
                }
                OperationsEventos.getEvento(function(res){
                    $scope.listaEventos=res;
                });
            });

        };
        //Endpoints de la actividades
        $scope.getlistaActivities =OperationsEventos.getActivity(JSON.parse(localStorage.getItem("event.id")),function(res){
            $scope.listaActivities=res;
        });
        $scope.postActivities=function(activity){
            $scope.activityofevent.idEvento=JSON.parse(localStorage.getItem("event.id"));
            console.log($scope.activityofevent);
            console.log("tipo:")
            console.log(typeof $scope.activityofevent.idEvento)
            var fecha=$scope.activityofevent.fecha.getFullYear()+"-"+$scope.activityofevent.fecha.getMonth()+"-"+$scope.activityofevent.fecha.getDate();
            console.log("fecha:"+fecha);
            $scope.activityofevent.fecha=fecha;
            OperationsEventos.insertActivity($scope.activityofevent,function(res){
                if(res){
                    console.log("res")
                    console.log(res);
                    $scope.listaActivities=res;
                    $location.path('activities');
                    $route.reload();
                }
            });
        }
        $scope.putActivities=function(activity){
            console.log(activity);
            OperationsEventos.updateActivity($scope.activity,function(res){
                if(res){
                    $scope.listaActivities=res;
                    $location.path('activities');
                    $route.reload();
                }
            });
        }
        $scope.delete=function deleteActivity(actividad){
            OperationsEventos.deleteActivities($scope.act_event,function(response){
                if(response){
                    $scope.listaActivities=response;
                    $location.path('activities');
                    $route.reload();
                }
            });
        };
        $scope.actualizarActividad=function actualizarActividad(actividad){
            $scope.activity=actividad;

        }
        $scope.actualizarActividadofEvent=function actualizarActividadofEvent(actividad){
            $scope.act_event.idEvento=JSON.parse(localStorage.getItem("event.id"));
            $scope.act_event.idActividad=actividad.idActividad;
            console.log(actividad);
        }
    });