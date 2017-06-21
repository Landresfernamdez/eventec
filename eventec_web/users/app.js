angular.module('userModule',['ngRoute'])
.config(['$routeProvider',function($routeProvider)
    {
        $routeProvider
                    .when("/activities",{
                        templateUrl:'activities/getActivities.html',
                        controller: 'activitiesController'
                                             })
                    .when("/events",{
                        templateUrl:'Eventos/getEventos.html',
                        controller: 'eventosController'
                                             })

    }
]);