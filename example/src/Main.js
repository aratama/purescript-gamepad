exports.rquestAnimationFrame = function(callback){
    return function(){
        window.requestAnimationFrame(function(){
            callback();
        });
    }
}