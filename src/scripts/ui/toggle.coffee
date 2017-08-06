
class ContentFlow.ToggleUI extends ContentTools.WidgetUI

    # An toggle switch widget

    constructor: () ->
        super()

        # The state of the toggle switch
        @_state = 'off'

        # Flag indicating if the toggle switch is currently enabled
        @_enabled = true

    # Read-only

    enabled: () ->
        return @_enabled

    # Methods

    disable: () ->
        # Disable the toggle switch
        if @dispatchEvent(@createEvent('disable'))
            @_enabled = false
            if @isMounted()
                @addCSSClass('ct-toggle--disabled')

    enable: () ->
        # Enable the toggle switch
        if @dispatchEvent(@createEvent('enable'))
            @_enabled = true
            if @isMounted()
                @removeCSSClass('ct-toggle--disabled')

    mount: () ->
        super()

        # Create the DOM elements for the switch, on and off components and
        # mount them.
        @_domElement = @constructor.createDiv([
            'ct-widget',
            'ct-toggle',
            'ct-toggle--off'
            ])
        @_domOff = @constructor.createDiv([
            'ct-toggle__button'
            'ct-toggle__button--off'
            ])
        @_domElement.appendChild(@_domOff)
        @_domOn = @constructor.createDiv([
            'ct-toggle__button'
            'ct-toggle__button--on'
            ])
        @_domElement.appendChild(@_domOn)
        @parent().domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

    off: () ->
        # Switch the toggle switch to the 'off' state
        if @dispatchEvent(@createEvent('off'))
            @state('off')

    on: () ->
        # Switch the toggle switch to the 'on' state
        if @dispatchEvent(@createEvent('on'))
            @state('on')

    state: (state) ->
        # Get/set the state of the toggle switch

        # If no state value is provided return the current state
        if state is undefined
            return state

        # If the state hasn't changed there's nothing to do so return
        if @state is state
            return

        # Dispatch the `statechange` event with details of the change
        unless @dispatchEvent(@createEvent('statechange', {state: state}))
            return

        # Modify the toggle state
        @_state = state

        # Remove existing state modifiers
        if @isMounted()
            @removeCSSClass('ct-toggle--off')
            @removeCSSClass('ct-toggle--on')

            if @_state is 'on'
                @addCSSClass('ct-toggle--on')
            else
                @addCSSClass('ct-toggle--off')

    toggle: () ->
        # Togg the state of the switch
        if @_state is 'on'
            @off()
        else
            @on()

    unmount: () ->
        super()

        # Remove references to other elements
        this._domOn = null
        this._domOff = null

    # Private methods

    _addDOMEventListeners: () ->
        super()

        # Handle click events for the off/on buttons

        @_domOff.addEventListener 'click', (ev) =>
            ev.preventDefault()
            if @_enabled
                @off()

        @_domOn.addEventListener 'click', (ev) =>
            ev.preventDefault()
            if @_enabled
                @on()