exports.rquestAnimationFrame = function(callback){
    return function(){
        window.requestAnimationFrame(function(){
            callback();
        });
    }
}

exports.setButtonState = function(state){
    return function(index){
        return function(){
            var element = document.querySelector("object").contentWindow.document.querySelector("#button" + index.toString().padStart(2, "0"))
            if(element){
                if(state){
                    element.style.fill = "yellow"
                }else{
                    element.style.fill = "#c8c8c8"
                }
            }
        }
    }
}

exports.setButtonPosition = function(name){
    return function(value){
        return function(index){
            return function(){
                var element = document.querySelector("object").contentWindow.document.querySelector("#button" + index.toString().padStart(2, "0"))
                if(element){
                    element.style[name] = value
                }
            }
        }
    }
}