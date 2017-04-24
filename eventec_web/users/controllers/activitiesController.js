angular.module('userModule')
.controller('activitiesController',function($scope,GetActivities){
	
	console.log("entro");
	$scope.getlistaActivities =GetActivities.respuesta(function(res){
		console.log(res);
		$scope.listaActivities=res;
		console.log($scope.listaActivities);
	});
});
