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
        };
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
        $scope.cargarModal = function (evento){
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
        function getMonthFromString(mon){
            var d = Date.parse(mon + "1, 2012");
            if(!isNaN(d)){
                return new Date(d).getMonth() + 1;
            }
            return -1;
        }
        $scope.crearEvento =function(){
            var monI=parseInt($scope.event.fechaInicio.getMonth());
            var monf=parseInt($scope.event.fechaFinal.getMonth());
            monI=monI+1;
            monf=monf+1;
            var fechaI=$scope.event.fechaInicio.getFullYear()+"-"+ monI+"-"+$scope.event.fechaInicio.getDate();
            var fechaF=$scope.event.fechaFinal.getFullYear()+"-"+monf+"-"+$scope.event.fechaFinal.getDate();
            if($scope.event.fechaInicio<$scope.event.fechaFinal){
                $scope.event.fechaInicio=fechaI;
                $scope.event.fechaFinal=fechaF;
                $scope.eventofuser.cedula=sessionStorage.getItem("session.user");
                $scope.eventofuser.nombre=$scope.event.nombre;
                $scope.eventofuser.descripcion=$scope.event.descripcion;
                $scope.eventofuser.fechaInicio=$scope.event.fechaInicio;
                $scope.eventofuser.fechaFinal=$scope.event.fechaFinal;
                console.log($scope.eventofuser);
                OperationsEventos.insertEvents($scope.eventofuser,function(res){
                    if(res){
                        OperationsEventos.getEvento(function(res){
                            console.log("res");
                            console.log(res);
                            $scope.listaEventos=res;
                        });
                    }
                });
            }
            else if($scope.event.fechaInicio>$scope.event.fechaFinal){
                alert("La fecha de inicio debe ser menor a la fecha final");
            }
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
        $scope.actualizarEvento = function(evento){
            $scope.event=evento;
        };
        
        $scope.getlistaEventos =function getlistaEventos(){
            var tipo='';
            if(document.getElementById("select_categoria_evento").value=='Futuros'){
                tipo='f';
            }
            if(document.getElementById("select_categoria_evento").value=='Pasados'){
                tipo='p';
            }
            if(document.getElementById("select_categoria_evento").value=='Todos'){
                tipo='t';
            }
            var filtro={filtro:tipo
            ,cedula:sessionStorage.getItem("user")}; 
            console.log(filtro);
            OperationsEventos.getEvento(filtro.cedula,filtro.tipo,function(res){
                $scope.listaEventos=res;
        });
        }
        $scope.getlistaEventos();
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
            var month=parseInt($scope.activityofevent.fecha.getMonth())+1;
            var fecha=$scope.activityofevent.fecha.getFullYear()+"-"+month+"-"+$scope.activityofevent.fecha.getDate();
            var duracion=$scope.activityofevent.horaFinal-$scope.activityofevent.horaInicio;
            var temporal={
                nombre:$scope.activityofevent.nombre,
                descripcion:$scope.activityofevent.descripcion,
                fecha:fecha,
                cupo:$scope.activityofevent.cupo,
                lugar:$scope.activityofevent.lugar,
                horaInicio:$scope.activityofevent.horaInicio,
                horaFinal:$scope.activityofevent.horaFinal,
                duracion:new Date(duracion),
                idEvento:$scope.activityofevent.idEvento
            }
            if($scope.activityofevent.horaFinal>$scope.activityofevent.horaInicio){
                console.log(temporal);
                OperationsEventos.insertActivity(temporal,function(res){
                    if(res){
                        console.log("res")
                        console.log(res);
                        $scope.listaActivities=res;
                        $location.path('activities');
                        $route.reload();
                    }
                });
            }
            else{
                alert("La hora final debe ser mayor a la hora inicial");
            }
        };
        $scope.putActivities=function(activity){
            activity.fecha=new Date(activity.fecha);
            var month=parseInt(activity.fecha.getMonth())+1;
            activity.fecha= activity.fecha.getFullYear()+"-"+month+"-"+activity.fecha.getDate()
            console.log(activity.fecha);
            var duracion1=activity.horaFinal-activity.horaInicio;
            activity.duracion=new Date(duracion1);
            console.log(activity);
            if(activity.horaFinal>activity.horaInicio){
                OperationsEventos.updateActivity(activity,function(res){
                    if(res){
                        $location.path('activities');
                        $route.reload();
                    }
                });
            }
            else{
                alert("La hora final tiene que ser mayor a la hora de inicio");
            }
        };
        $scope.delete=function deleteActivity(actividad){
            OperationsEventos.deleteActivities($scope.act_event,function(response){
                if(response){
                    $location.path('activities');
                    $route.reload();
                }
            });
        };
        $scope.actualizarActividad=function actualizarActividad(actividad){
            console.log("entro a prueba:");
            $scope.activity=actividad;
            console.log(actividad);
        };
        $scope.actualizarActividadofEvent=function actualizarActividadofEvent(actividad){
            $scope.act_event.idEvento=JSON.parse(localStorage.getItem("event.id"));
            $scope.act_event.idActividad=actividad.idActividad;
            console.log(actividad);
        };
        //Endpoints de la personas
        console.log("nada:"+$scope.activity.idActividad);
        $scope.getlistaPersonas = function(){
            OperationsEventos.getPersona($scope.activity.idActividad,function(res){
                console.log(res);
                $scope.listaPersonas=res;
            });
        };
        $scope.actualizarActividadPersonas=function actualizarActividadPersonas(actividad){
            console.log("entro a prueba:");
            $scope.activity=actividad;
            $scope.getlistaPersonas();
        };
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
        };
        //Obtener todos los administradores del sistema
        $scope.getlistaAdministradores = function(){
            OperationsEventos.getAdministrador(function(res){
                $scope.listaAdministradores=res;
            });
        };
        $scope.getlistaAdministradores();
        
        $scope.asignarAdministrador=function asignarAdministrador(cedula){
            console.log("ced:"+cedula+","+"id:"+$scope.event.idEvento);
            var AdministradorEvento={
                idEvento:$scope.event.idEvento,
                cedula:cedula
            }
            OperationsEventos.asignarAdministrador(AdministradorEvento,function(response){
                if(response){
                    $scope.listaPersonas=response;
                    $scope.actualizarPersonas($scope.persona);
                    $scope.getlistaPersonas();
                    $location.reload();
                }
            });
        }
    });