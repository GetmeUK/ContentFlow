
class ContentFlow.FieldUI extends ContentTools.ComponentUI

    # A field (data entry) component

    constructor: (name, label, required, initialValue) ->
        super()

        # The name of the field (used as the parameter name when submitted as
        # a web request).
        @_name = name

        # The label displayed for the field
        @_label = label

        # A flag indicating if the field is required
        @_required = required

        # The initial value of the field
        @_initialValue = initialValue

    # Methods

    errors: (errors) ->
        # Get/set the errors for the field

        # The value is managed via the input DOM element(s) and therefore the
        # component must be mounted for this function to be called.
        unless @isMounted()
            throw Error('Cannot set error for unmounted field')

        # If no errors are provided return the current errors
        if value is undefined
            errors = []
            for domError in @_domErrors.querySelector('.ct-field__error')
                errors.push(domError.textContent)
            return errors

        # Set the errors

        # Clear any existing errors
        @_domErrors.innerHTML = ''
        @_domErrors.classList.add('ct-field-errors__empty')

        if errors
            # Populate the errors DOM element
            for error in errors
                domError = @constructor.createDiv(['ct-field__error'])
                domError.textContent = error
                @_domErrors.appendChild(domError)
            @_domErrors.classList.remove('ct-field-errors__empty')

    mount: () ->
        super()

        # Create the DOM element for the field
        @_domElement = @constructor.createDiv([
            'ct-field',
            'ct-field--required' if @_required else 'ct-field--optional'
        ])

        # Create the DOM element for the field label and attach it
        @_domLabel = document.createElement('label')
        @_domLabel.classList.add('ct-field__label')
        @_domLabel.setAttribute('for', @_name)
        @_domLabel.textContent = @_label
        @_domElement.appendChild(@_domLabel)

        # Create the DOM element for the field input
        @mount_input()

        # Create the DOM element for the field errors
        @_domErrors = @constructor.createDiv([
            'ct-field_errors',
            'ct-field_errors__empty'
        ])
        @_domElement.appendChild(@_domErrors)

        # Mount the field to the DOM
        @parent.domElement().appendChild(@_domElement)
        @_addDOMEventListeners()

    mount_input: () ->
        # Mount the input element for the field

    value: (value) ->
        # Get/set the value for the field

        # The value is managed via the input DOM element(s) and therefore the
        # component must be mounted for this function to be called.
        unless @isMounted()
            throw Error('Cannot set value for unmounted field')

        # If no heading value is provided return the current heading
        if value is undefined
            return @_domInput.value

        # Set the value
        @_domInput.value = value

    unmount: () ->
        super()

        # Remove references to other elements
        this._domErrors = null
        this._domInput = null
        this._domLabel = null


class ContentFlow.BooleanFieldUI extends ContentFlow.FieldUI

    # A boolean field component

    mount: () ->
        super()
        @_domElement.classList.add('ct-field--boolean')

    mount_input: () ->
        # Mount the input element for the field
        @_domInput = document.createElement('input')
        @_domInput.classList.add('ct-field__input')
        @_domInput.classList.add('ct-field__input--boolean')
        @_domInput.setAttribute('id', @_name)
        @_domInput.setAttribute('name', @_name)
        @_domInput.setAttribute('type', 'checkbox')
        if @_initialValue
            @_domInput.setAttribute('checked', true)
        @_domElement.appendChild(@_domInput)

    value: (value) ->
        # Get/set the value for the field

        # The value is managed via the input DOM element(s) and therefore the
        # component must be mounted for this function to be called.
        unless @isMounted()
            throw Error('Cannot set value for unmounted field')

        # If no heading value is provided return the current heading
        if value is undefined
            if @_domInput.checked
                return @name
            return ''

        # Set the value
        @_domInput.removeAttribute('checked')
        if value
            @_domInput.setAttribute('checked', true)


class ContentFlow.SelectFieldUI extends ContentFlow.FieldUI

    # A select field component

    constructor: (name, label, required, initialValue, options) ->
        super(name, label, required, initialValue, options)

        # The options for the select field
        @_options = options

    # Read-only

    options: () ->
        return @_options

    # Methods

    mount: () ->
        super()

        # Add the select element
        @_domInput = document.createElement('select')
        @_domInput.classList.add('ct-field__input')
        @_domInput.classList.add('ct-field__input--select')
        @_domInput.setAttribute('id', @_name)
        @_domInput.setAttribute('name', @_name)

        # Add the options
        for option in @_options
            domOption - document.createElement('option')
            domOption.setAttribute('value', option[0])
            domOption.textContent = option[1]
            if @_initialValue is option[0]
                @_domInput.setAttribute('selected', true)
            @_domInput.appendChild(domOption)

        @_domElement.appendChild(@_domInput)


class ContentFlow.TextFieldUI extends ContentFlow.FieldUI

    # A text input field component

    mount: () ->
        super()

        # Add the input element
        @_domInput = document.createElement('input')
        @_domInput.classList.add('ct-field__input')
        @_domInput.classList.add('ct-field__input--text')
        @_domInput.setAttribute('id', @_name)
        @_domInput.setAttribute('name', @_name)
        @_domInput.setAttribute('type', 'text')
        @_domInput.setAttribute('value', @_initialValue)
        @_domElement.appendChild(@_domInput)
