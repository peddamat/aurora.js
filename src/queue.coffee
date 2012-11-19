class AV.Queue extends AV.EventEmitter
    constructor: (@decoder) ->
        @readyMark = 64
        @finished = false
        @buffering = true
        
        @buffers = []
        @decoder.on 'data', @write
        @decoder.decode()
        
    write: (buffer) =>
        @buffers.push buffer if buffer
        
        if @buffering
            if @buffers.length >= @readyMark# or @decoder.receivedFinalBuffer
                @buffering = false
                @emit 'ready'
            else    
                @decoder.decode()
            
    read: ->
        return null if @buffers.length is 0
        
        @decoder.decode()    
        return @buffers.shift()
        
    reset: ->
        @buffers.length = 0
        @buffering = true
        @decoder.decode()