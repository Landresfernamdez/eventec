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
                    .when("/main",{
                    templateUrl:'../index.html',
                    controller: 'eventosController'
                    })
                    .when("/login",{
                    templateUrl:'../index.html',
                    controller: 'eventosController'
                    })
    }
]);