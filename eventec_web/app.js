angular.module('userModule',['ngRoute'])
.config(['$routeProvider',function($routeProvider)
    {
        $routeProvider
                    .when("/",{
                        templateUrl:'index.html',
                        controller: 'loginController'
                    })
                    .when("/activities",{
                        templateUrl:'activities/activities.html',
                        controller: 'activitiesController'
                                             })
                    .when("/events",{
                        templateUrl:'eventos/eventos.html',
                        controller: 'eventosController'
                                             })
                    .when("/peoples",{
                        templateUrl:'personas/personas.html',
                        controller: 'personasController'
                    })
    }
]);