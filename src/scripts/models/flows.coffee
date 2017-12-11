
class ContentFlow.FlowModel

    # Content flows allow the flow of content within different sections of a
    # page to be managed through smaller sections of prefabricated content
    # know as snippets.

    constructor: (id, label=null, snippetTypes=[]) ->

        # A unique Id for the flow (at least within the page)
        @id = id

        # A human readable label for the flow
        @label = label or id

        # A list of snippet types available in the flow
        @snippetTypes = snippetTypes

    # Methods

    getSnippetTypeById: (snippetTypeId) ->
        # Return the snippet type
        for snippetType in @snippetTypes
            if snippetTypeId is snippetType.id
                return snippetType