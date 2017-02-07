
exports._getGamepads = function _getGamepads(){
    return Array.prototype.map.call(navigator.getGamepads ? navigator.getGamepads() : [], function(gamepad){
        if(gamepad){
            return {
                id: gamepad.id,
                index: gamepad.index,
                mapping: gamepad.mapping,
                connected: gamepad.connected,
                buttons: Array.prototype.map.call(gamepad.buttons, function(button){
                    return {
                        value: button.value,
                        pressed: button.pressed
                    }
                }),
                axes: Array.prototype.slice.call(gamepad.axes),
                timeStamp: gamepad.timeStamp
            };
        }else{
            return null;
        }
    });
};

exports.getGamepad = function getGamepad(e){
    return e.gamepad;
};

exports._addGamepadEventListener = function _addGamepadEventListener(eventType){
    return function (callback){
        return function(){
            window.addEventListener(eventType, function(e){
                callback(e)();
            });
        };
    };
};