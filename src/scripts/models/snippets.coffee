
class ContentFlow.Snippet

    # Content flows are made up of snippets of HTML. Snippets allow different
    # prefabricated sections of HTML to be entered into a flow before being
    # updated via the ContentTools editor.

    constructor: (id, type, scope='local', settings={}) ->

        # A unique Id (at least within the flow) for the snippet
        @id = id

        # The type of snippet (see SnippetType)
        @type = type

        # The scope of the snippet ('local', 'global')
        @scope = scope

        # A table of settings for the snippet
        @settings = settings


class ContentFlow.SnippetType

    # Snippets are created based on a SnippetType. The snippet type defines

    constructor: (id, label, imageURL=null) ->

        # A unique Id for the snippet type (at least within the flows on the
        # page).
        @id = id

        # A descriptive label for the snippet type
        @label = label

        # An (optional) preview image for the snippet type
        @imageURL = imageURL