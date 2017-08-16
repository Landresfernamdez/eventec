angular.module('userModule')
.controller('activitiesController',function($scope,OperationsActivities,$location,$route){

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
	});
	$scope.postActivities=function(activity){
		console.log(activity);
		OperationsActivities.insertActivity($scope.activity,function(res){
			if(res){
					$scope.listaActivities=res;
				    $location.path('activities');
				    $route.reload();
			}
		});
	}
    $scope.putActivities=function(activity){
        console.log(activity);
        OperationsActivities.updateActivity($scope.activity,function(res){
            if(res){
            	$scope.listaActivities=res;
                $location.path('activities');
                $route.reload();
            }
        });
    }
	$scope.delete=function deleteActivity(actividad){
		OperationsActivities.deleteActivities($scope.activity,function(response){
				if(response){
					$scope.listaActivities=response;
				    $location.path('activities');
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
