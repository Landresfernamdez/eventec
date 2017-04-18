/**
 * Created by Erwin on 25/10/2016.
 */
angular.module('userModule',["ngRoute","ngResource"])
.config(['$routeProvider',function($routeProvider)
    {
        $routeProvider.when("/user",{
            templateUrl:'dashboard.html',
            controller: 'dashboardCtrl'
        })
            .when("/user/reserve",{
                templateUrl:'reservations/create.html',
                controller: 'reservationsCreateCtrl'
            })
            .when("/user/fleet",{
                templateUrl:'fleet/index.html',
                controller: 'fleetIndexCtrl'
            })
            .when("/user/reserves",{
                templateUrl:'reserves/myreserves.html',
                controller: 'myreservesCtrl'
            })

    }
]);
