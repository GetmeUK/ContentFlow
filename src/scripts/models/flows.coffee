
class ContentFlow.Flow

    # Content flows allow the flow of content within different sections of a
    # page to be managed through smaller sections of prefabricated content
    # know as snippets.

    constructor: (id) ->

        # A unique Id for the flow (at least within the page)
        @id = id