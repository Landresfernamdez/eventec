angular.module('userModule')
.controller('activitiesController',function($scope,OperationsActivities){
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
				});
				window.location.href = ('activities');
			}
		});

	}
});
