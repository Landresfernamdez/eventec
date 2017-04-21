angular.module('mainModule',["ngRoute","ngResource"])
.controller('mainController',function($scope,$http){
	$scope.jumpGetevents=function(){
            window.location.href=('../events/views/getEvents.html');
                                    };
                              
	
});