angular.module('userModule',['ngRoute'])
.config(['$routeProvider',function($routeProvider)
    {
        $routeProvider.when("/",{
                        templateUrl:'index.html',
                        controller: 'loginController'
                    })
                    .when("/activities",{
                        templateUrl:'activities.html',
                        controller: 'eventosController'
                                             })
                    .when("/events",{
                        templateUrl:'eventos.html',
                        controller: 'eventosController'
                                             })
                    .when("/peoples",{
                        templateUrl:'../personas/personas.html',
                        controller: 'personasController'
                    })
                    .when("/main",{
                    templateUrl:'users/index.html',
                    controller: 'eventosController'
                    })
    }
]);