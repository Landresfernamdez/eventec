angular.module('userModule',['ngRoute'])
.config(['$routeProvider',function($routeProvider)
    {
        $routeProvider
                    .when("/users/activities",{
                        templateUrl:'activities/getActivities.html',
                        controller: 'activitiesController'
                                             })

    }
]);