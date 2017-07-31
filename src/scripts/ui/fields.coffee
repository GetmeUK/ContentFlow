
class ContentFlow.FieldUI extends ContentTools.ComponentUI

    # A field (data entry) component

    # A map of field types and the UI classes that handle them
    @_typeMap = {}

    constructor: (name, label, type, required, initialValue) ->
        super()

        # The name of the field (used as the parameter name when submitted as
        # a web request).
        @_name = name

        # The label displayed for the field
        @_label = label

        # The type of data-entry field field to display (only a limited set of
        # field types are currently supported, if the type is not recognized a
        # standard text input field will be displayed.
        @_type = type

        # A flag indicating if the field is required
        @_required = required

        # The initial value of the field
        @_initialValue = initialValue

    # Methods

    errors: () ->

        # @@

    mount: () ->
        super()

        # Create the DOM element for the field
        @_domElement = @constructor.createDiv([
            'ct-field',
            "ct-field--type-#{ @_type.toLowerCase() }",
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
        @_domInput = document.createElement('input')
        @_domInput.classList.add('ct-field__input')
        @_domInput.classList.add('ct-field__input--text')
        @_domInput.setAttribute('id', @_name)
        @_domInput.setAttribute('name', @_name)
        @_domInput.setAttribute('type', 'text')
        @_domInput.setAttribute('value', @_initialValue)

    value: (value) ->
        # Get/set the value for the field

        # The value is managed via the input DOM element(s) and therefore the
        # component must be mounted for this function to be called.
        unless @isMounted()
            throw Error('Cannot set value for unmounted field')

        # @@ START HERE


# @@ Boolean, Select, Text