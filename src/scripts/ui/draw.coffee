
class ContentFlow.DrawUI extends ContentTools.ComponentUI

    # A UI component that slides in/out of the screen (by default from the
    # right side of the screen).
    #
    # Draws allow user interfaces to be hidden when not needed and easily
    # accessed/revealed when required.

    constructor: () ->
        super()

        # The state of the draw
        @_state = 'closed'

    # Methods

    open: () ->
        # Open the draw
        if @dispatchEvent(@createEvent('open'))
            @state('open')

    close: () ->
        # Close the draw
        if @dispatchEvent(@createEvent('close'))
            @state('closed')

    mount: () ->
        super()

        # Create the DOM element for the draw and mount it
        @_domElement = @constructor.createDiv(['ct-draw', 'ct-draw--closed'])
        @parent().domElement()
        @_addDOMEventListeners()

        # Mount children
        for child in @children()
            child.mount()

    state: (state) ->
        # Get/set the state of the draw

        # If no state value is provided return the current state
        if state is undefined
            return state

        # If the state hasn't changed there's nothing to do so return
        if @state is state
            return

        # Dispatch the `statechange` event with details of the change
        unless @dispatchEvent(@createEvent('statechange', {state: state}))
            return

        # Modify the draw state
        @_state = state

        # Remove existing state modifiers
        @removeCSSClass('ct-draw--open')
        @removeCSSClass('ct-draw--closed')

        if @state() is 'open'
            @addCSSClass('ct-draw--open')
        else
            @addCSSClass('ct-draw--closed')
