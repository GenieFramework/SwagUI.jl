module SwaggerUI

using JSON
using Genie, Genie.Router

# include("Setup.jl")
include("Options.jl")
include("Builders.jl")

# setup()

const JS_PATH = joinpath(dirname(dirname(@__FILE__)), "dist")
export Options, render_swagger, serve_assets, build_js_string, build_html_string

function render_swagger(swagger_doc::Union{Dict{String, Any}, Nothing}; options::Options=Options())::String
    serve_assets(JS_PATH, excludes=["index.html"])

    js_string = build_js_string(options, swagger_doc)
    html_string = build_html_string(options, js_string)

    return html_string
end

# serve assets
function serve_assets(path::String; excludes::Array{String, 1}=Array{String, 1}())
    for (root, dirs, files) in walkdir(path)
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
