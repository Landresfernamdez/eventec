angular.module('userModule')
.controller('activitiesController',function($scope,OperationsActivities,$location){
	console.log("entro");
	$scope.activity={
		idActividad:"",
		nombre:"",
		descripcion:"",
		fecha:"",
		cupo:"",
		lugar:"",
		horaInicio:"",
		horaFinal:"",
		duracion:""
	};
	$scope.getlistaActivities =OperationsActivities.getActivity(function(res){
		console.log(res);
		$scope.listaActivities=res;
		console.log($scope.listaActivities);
	});
	$scope.postActivities=function(activity){
		console.log(activity);
		OperationsActivities.insertActivity($scope.activity,function(res){
			if(res){
				OperationsActivities.getActivity(function(res){
					console.log(res);
					$scope.listaActivities=res;
					console.log($scope.listaActivities);
				    $location.path('contactos');
				    $route.reload();
				});
			}
		});
	}
	$scope.delete=function deleteActivity(actividad){
		console.log("imprime:"+$scope.activity);
		OperationsActivities.deleteActivities($scope.activity,function(response){
				if(response.success){
				    $location.path('contactos');
				    $route.reload();
				}
		});

	};

	$scope.actualizarActividad=function actualizarActividad(actividad){
		$scope.activity=actividad;
		console.log("actualiza:");
		console.log(actividad);

	}
});
