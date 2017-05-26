angular.module('userModule',['ngRoute'])
.config(['$routeProvider',function($routeProvider)
    {
        $routeProvider
                    .when("/users/activities",{
                        templateUrl:'activities/getActivities.html',
                        controller: 'activitiesController'
                                             })
                    .when("/users/events",{
                        templateUrl:'Eventos/getEventos.html',
                        controller: 'eventosController'
                                             })

    }
]);