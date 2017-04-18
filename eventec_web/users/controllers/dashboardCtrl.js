**
 * Created by Erwin on 25/10/2016.
 */

angular.module('userModule')
    .controller('dashboardCtrl', function($scope,MessageResource) {
    /* config object */

    $scope.getMessages=MessageResource.getMessages(function (res) {
        console.log("res ", res);
        $scope.messages=res
    });
        $scope.postMessage=function() {
            console.log("envio",$scope.message)
            MessageResource.setMessage($scope.message);

        }
});