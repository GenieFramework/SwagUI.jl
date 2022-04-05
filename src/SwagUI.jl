module SwagUI

using JSON

include("Options.jl")
include("Builders.jl")

export Options, render_swagger

"""
    render_swagger(swagger_doc::Union{Dict{String, Any}, Nothing})::String

Render Swagger UI's HTML as `String`, based on the options passed in. If a vaid `swagger_doc` is passed,
the `url` and `urls` in the `Options.swagger_options` are ignored by the UI. If `swagger_doc` is `nothing`,
`url` or `urls` has to be included in the `Options.swagger_options`.

# Arguments
Required:
- `swagger_doc::Union{Dict{String, Any}, Nothing}` : The swagger specification file `swagger.json` as a `Dict{String, Any}`.
"""
function render_swagger(swagger_doc::Union{Dict{String, Any}, Nothing}; options::Options=Options())::String
    js_string = build_js_string(options, swagger_doc)
    html_string = build_html_string(options, js_string)

    return html_string
end

end # module
