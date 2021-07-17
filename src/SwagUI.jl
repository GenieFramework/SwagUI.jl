module SwagUI

using JSON
using Genie, Genie.Router

include("Options.jl")
include("Builders.jl")

const JS_PATH = joinpath(dirname(dirname(@__FILE__)), "dist")
export Options, render_swagger, serve_assets, build_js_string, build_html_string

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
    serve_assets(JS_PATH, excludes=["index.html"])

    js_string = build_js_string(options, swagger_doc)
    html_string = build_html_string(options, js_string)

    return html_string
end


"""
    serve_assets(path::String)

Serve static files from a given folder `path`. `excludes` contains a list of file names that need to be skipped.

# Arguments
Required:
- `path::String` : The path of the folder that contains the files to serve.
"""
function serve_assets(path::String; excludes::Array{String, 1}=Array{String, 1}())
    for (root, _, files) in walkdir(path)
        for file in files
            if !(file in excludes)
                route(file) do 
                    serve_static_file(file, root=root)
                end
            end
        end
    end
end

end # module
