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
        $scope.eventofuser={
            cedula:"",
            nombre:"",
            descripcion:"",
            fechaInicio:"",
            fechaFinal:""
        };
        $scope.persona={
            cedula:"",
            nombre:"",
            apellido1:"",
            apellido2:"",
            estado:"",
            edad:"",
            direccion:""
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
            var fechaI=$scope.event.fechaInicio.getFullYear()+"-"+$scope.event.fechaInicio.getMonth()+"-"+$scope.event.fechaInicio.getDate();
            var fechaF=$scope.event.fechaFinal.getFullYear()+"-"+$scope.event.fechaFinal.getMonth()+"-"+$scope.event.fechaFinal.getDate();
            $scope.event.fechaInicio=fechaI;
            $scope.event.fechaFinal=fechaF;
            $scope.eventofuser.cedula=sessionStorage.getItem("user.id");
            $scope.eventofuser.nombre=$scope.event.nombre;
            $scope.eventofuser.descripcion=$scope.event.descripcion;
            $scope.eventofuser.fechaInicio=$scope.event.fechaInicio;
            $scope.eventofuser.fechaFinal=$scope.event.fechaFinal;
            OperationsEventos.insertEvents($scope.eventofuser,function(res){
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
            console.log("entro a prueba:");
            $scope.activity=actividad;
            console.log(actividad);
        }
        $scope.actualizarActividadofEvent=function actualizarActividadofEvent(actividad){
            $scope.act_event.idEvento=JSON.parse(localStorage.getItem("event.id"));
            $scope.act_event.idActividad=actividad.idActividad;
            console.log(actividad);
        }
        //Endpoints de la personas
        console.log("nada:"+$scope.activity.idActividad);
        $scope.getlistaPersonas = function(){
            OperationsEventos.getPersona($scope.activity.idActividad,function(res){
                console.log(res);
                $scope.listaPersonas=res;
            });
        }

        $scope.actualizarActividadPersonas=function actualizarActividadPersonas(actividad){
            console.log("entro a prueba:");
            $scope.activity=actividad;
            $scope.getlistaPersonas();
        }
        $scope.deletePersonas=function deletePersona(){
            var ActividadPersona={
                idActividad:$scope.activity.idActividad,
                cedula:$scope.persona.cedula
            }
            OperationsEventos.deletePersonas(ActividadPersona,function(response){
                if(response){
                    $scope.listaPersonas=response;
                    $scope.actualizarPersonas($scope.persona);
                    $scope.getlistaPersonas();
                    $location.reload();
                }
            });

        };
        $scope.actualizarPersonas=function actualizarPersonas(persona){
            $scope.persona=persona;
            console.log("actualiza:");
            console.log(persona);

        }
    });